//
//  FaceImageView.h
//  Camena
//
//  Created by Dan Hassin on 6/28/13.
//  Copyright (c) 2013 Dan Hassin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceImageView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL faceTrackingEnabled;

@property (nonatomic, readonly) int numberOfFacesDetected;

@end
