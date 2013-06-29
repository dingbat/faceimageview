//
//  ViewController.m
//  FaceImageView
//
//  Created by Dan Hassin on 6/28/13.
//  Copyright (c) 2013 Dan Hassin. All rights reserved.
//

#import "ViewController.h"
#import "FaceImageView.h"

@implementation ViewController
{
	FaceImageView *face;
}

- (void)viewDidLoad
{
	self.view.backgroundColor = [UIColor whiteColor];
	
	face = [[FaceImageView alloc] initWithFrame:CGRectZero];
    face.layer.borderColor = [UIColor blackColor].CGColor;
    face.layer.borderWidth = 1;
    face.image = [UIImage imageNamed:@"gold-panda"];
	face.faceTrackingEnabled = YES;
    [self.view addSubview:face];
	
	UISlider *wSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 10, 150, 35)];
	wSlider.minimumValue = 10;
	wSlider.maximumValue = 300;
	wSlider.value = 320;
	[wSlider addTarget:self action:@selector(changeWidth:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:wSlider];
	
	UISlider *hSlider = [[UISlider alloc] initWithFrame:CGRectMake(10+150, 10, 150, 35)];
	hSlider.minimumValue = 10;
	hSlider.maximumValue = 320;
	hSlider.value = 200;
	[hSlider addTarget:self action:@selector(changeHeight:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:hSlider];
	
	[self changeHeight:hSlider];
	[self changeWidth:wSlider];
	
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) changeWidth:(UISlider *)slider
{
	face.frame = CGRectMake(10, 50, slider.value, face.frame.size.height);
}

- (void) changeHeight:(UISlider *)slider
{
	face.frame = CGRectMake(10, 50, face.frame.size.width, slider.value);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
