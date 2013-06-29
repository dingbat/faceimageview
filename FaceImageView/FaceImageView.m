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
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
		_faceTrackingEnabled = YES;
        self.userInteractionEnabled = NO;
		
		//flip rendering vertically, as we're drawing upside down (to agree with CI coordinate system)
		self.transform = CGAffineTransformMakeScale(1, -1);
    }
    return self;
}

- (void) calculateCentroidOfFaceLocations
{
    CIImage *ci = [[CIImage alloc] initWithImage:_image];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
	
    NSArray *faces = [detector featuresInImage:ci];
    _numberOfFacesDetected = faces.count;
    
    CGPoint centroid = CGPointZero;
    for (int i = 0; i < _numberOfFacesDetected; i++)
    {
		CIFaceFeature *face = faces[i];
        CGRect bounds = face.bounds;

        /*
        UIView *faceRect = [[UIView alloc] initWithFrame:bounds];
        faceRect.layer.borderWidth = 1;
        faceRect.layer.borderColor = [UIColor redColor].CGColor;
        [self addSubview:faceRect];
        */
		
        CGPoint center = CGPointMake(bounds.origin.x + bounds.size.width/2, bounds.origin.y + bounds.size.height/2);
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
    [_drawImage drawAtPoint:_drawPoint];
}

- (void) layoutSubviews
{
    [self positionImage];
}

@end
