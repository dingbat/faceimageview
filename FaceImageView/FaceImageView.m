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
        self.clipsToBounds = YES;
        self.userInteractionEnabled = NO;
		
		self.transform = CGAffineTransformMakeScale(1, -1);
    }
    return self;
}

- (CGPoint) getCentroidOfFaces
{
    CIImage *ci = [[CIImage alloc] initWithImage:_drawImage];
    
    CGFloat scaleIn = _drawImage.scale;
    CGFloat scaleOut = 1/_drawImage.scale;
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
	
    NSArray *faces = [detector featuresInImage:ci];
    
    CGPoint centroid = CGPointZero;
    for (int i = 0; i < faces.count; i++)
    {
		CIFaceFeature *face = faces[i];
		CGAffineTransform transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(scaleOut, scaleOut), _drawPoint.x*scaleIn, _drawPoint.y*scaleIn);
        CGRect bounds = CGRectApplyAffineTransform(face.bounds, transform);

        /*
        UIView *faceRect = [[UIView alloc] initWithFrame:bounds];
        faceRect.layer.borderWidth = 1;
        faceRect.layer.borderColor = [UIColor redColor].CGColor;
        [self addSubview:faceRect];
        */
        CGPoint center = CGPointMake(bounds.origin.x + bounds.size.width/2, bounds.origin.y + bounds.size.height/2);
        if (i == 0)
            centroid = center;
        else
            centroid = CGPointMake(fabs(centroid.x - center.x), fabs(centroid.y - center.y));
    }
    
    return centroid;
}

- (void) positionImage
{
    CGFloat scaleX = _image.scale*_image.size.height/self.bounds.size.height;
	CGFloat scaleY = _image.scale*_image.size.width/self.bounds.size.width;
	CGFloat scale = MIN(scaleX, scaleY);

    _drawImage = [[UIImage alloc] initWithCGImage:_image.CGImage scale:scale orientation:UIImageOrientationDownMirrored];
    _drawPoint = CGPointMake((self.bounds.size.width - _drawImage.size.width)/2, (self.bounds.size.height - _drawImage.size.height)/2);

    _centroid = [self getCentroidOfFaces];
	
	//centroid should be in the center
	if (!CGPointEqualToPoint(_centroid, CGPointZero) && _faceTrackingEnabled)
	{
		_drawPoint.x = -(_centroid.x-_drawPoint.x - self.bounds.size.width/2);
		_drawPoint.y = -(_centroid.y-_drawPoint.y - self.bounds.size.height/2);
	}

	//max offset is 0 (if we go beyond, it'll show black as inset)
	//min offset is the image size - our bounds (if we go before this there won't be enough image to cover up our bounds)
	_drawPoint.x = MAX(MIN(_drawPoint.x,0),-(_drawImage.size.width-self.bounds.size.width));
	_drawPoint.y = MAX(MIN(_drawPoint.y,0),-(_drawImage.size.height-self.bounds.size.height));
	
	[self setNeedsDisplay];
}

- (void) setImage:(UIImage *)image
{
    _image = image;
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
