//
//  FaceImageView.m
//  Camena
//
//  Created by Dan Hassin on 6/28/13.
//  Copyright (c) 2013 Dan Hassin. All rights reserved.
//

#import "FaceImageView.h"

#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

@implementation FaceImageView
{
    UIImage *_drawImage;
    CGPoint _drawPoint;
    CGPoint _centroid;
    
    CIDetector *_faceDetector;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _faceTrackingEnabled = YES;
        self.userInteractionEnabled = NO;
		
        _faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                           context:nil
                                           options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    }
    return self;
}

- (void) calculateCentroidOfFaceLocations
{
    CIImage *ci = [[CIImage alloc] initWithImage:_image];
    NSArray *faces = [_faceDetector featuresInImage:ci];
    _numberOfFacesDetected = faces.count;
    
    CGPoint centroid = CGPointZero;
    for (int i = 0; i < _numberOfFacesDetected; i++)
    {
		CIFaceFeature *face = faces[i];
        CGRect bounds = face.bounds;

        CGPoint center = CGPointMake(bounds.origin.x + bounds.size.width/2, bounds.origin.y + bounds.size.height/2);
        
        /* Move 75% towards the eyes, if detected */
        int numberOfEyesDetected = face.hasLeftEyePosition + face.hasRightEyePosition;
        CGPoint eyeCenter = CGPointMake((face.leftEyePosition.x + face.rightEyePosition.x)/numberOfEyesDetected,
                                        (face.leftEyePosition.y + face.rightEyePosition.y)/numberOfEyesDetected);
        if (!CGPointEqualToPoint(eyeCenter, CGPointZero))
        {
            center.x = (center.x + eyeCenter.x*3)/4;
            center.y = (center.y + eyeCenter.y*3)/4;
        }
        
        centroid.x += center.x;
		centroid.y += center.y;
    }
	
	if (_numberOfFacesDetected > 0)
	{
		centroid.x /= faces.count;
		centroid.y /= faces.count;
	}
    
    _centroid = centroid;
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    [self calculateCentroidOfFaceLocations];
    
    if (self.superview)
        [self positionImage];
}

- (void) positionImage
{
    CGFloat scaleX = _image.scale*_image.size.height/self.bounds.size.height;
	CGFloat scaleY = _image.scale*_image.size.width/self.bounds.size.width;
	CGFloat scale = MIN(scaleX, scaleY);

    _drawImage = [[UIImage alloc] initWithCGImage:_image.CGImage scale:scale orientation:UIImageOrientationDownMirrored];

	if (!_faceTrackingEnabled || CGPointEqualToPoint(_centroid, CGPointZero))
	{
		//simply center image in the view
		_drawPoint.x = (self.bounds.size.width - _drawImage.size.width)/2;
		_drawPoint.y = (self.bounds.size.height - _drawImage.size.height)/2;
	}
	else
	{
		//centroid should be in the center of our view
		_drawPoint.x = -(_centroid.x/scale - self.bounds.size.width/2);
		_drawPoint.y = -(_centroid.y/scale - self.bounds.size.height/2);

		//max offset is 0 (if we go beyond, it'll show black as inset)
		//min offset is the image size - our bounds (if we go before this there won't be enough image to cover up our bounds)
		_drawPoint.x = MAX(MIN(_drawPoint.x,0),-(_drawImage.size.width-self.bounds.size.width));
		_drawPoint.y = MAX(MIN(_drawPoint.y,0),-(_drawImage.size.height-self.bounds.size.height));
	}
	
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //flip context vertically, as the image is rendered upside down (to agree with the CI coordinate system)
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    [_drawImage drawAtPoint:_drawPoint];
}

- (void) layoutSubviews
{
    [self positionImage];
}

@end
