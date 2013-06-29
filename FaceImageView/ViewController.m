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
    UIView *controlsView;
	FaceImageView *imageView;
}

- (void)viewDidLoad
{
    /* Add a FaceImageView to our view */
    
	imageView = [[FaceImageView alloc] initWithFrame:CGRectZero];
    imageView.layer.borderColor = [UIColor blackColor].CGColor;
    imageView.layer.borderWidth = 1;
	[self.view addSubview:imageView];
	
    
    /* Add some controls for the demo */
    
    controlsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)];
    
    int margin = 10;
    int sliderWidth = (self.view.bounds.size.width-margin*3)/2;
    int sliderHeight = 35;
    
	UISlider *widthSlider = [[UISlider alloc] initWithFrame:CGRectMake(margin, margin*2, sliderWidth, sliderHeight)];
	widthSlider.minimumValue = margin;
	widthSlider.maximumValue = self.view.bounds.size.width-margin*2;
	widthSlider.value = widthSlider.maximumValue;
	[widthSlider addTarget:self action:@selector(changeWidth:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:widthSlider];
	
	UISlider *heightSlider = [[UISlider alloc] initWithFrame:CGRectMake(margin+sliderWidth+margin, margin*2, sliderWidth, sliderHeight)];
	heightSlider.minimumValue = margin;
	heightSlider.maximumValue = self.view.bounds.size.height-margin*2-controlsView.frame.size.height;
	heightSlider.value = heightSlider.maximumValue;
	[heightSlider addTarget:self action:@selector(changeHeight:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:heightSlider];
    
    UISegmentedControl *imageControl = [[UISegmentedControl alloc] initWithItems:@[@"1", @"2", @"3", @"4", @"5"]];
    imageControl.selectedSegmentIndex = 0;
    imageControl.frame = CGRectMake(margin, margin*2+sliderHeight+margin, self.view.bounds.size.width-margin*2, 35);
    [imageControl addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:imageControl];
	
	[self changeHeight:heightSlider];
	[self changeWidth:widthSlider];
    [self changeImage:imageControl];
    
    
	self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
}

- (void) changeImage:(UISegmentedControl *)control
{
    NSString *image = @[@"gp.jpg", @"gold-panda", @"beatles.jpg", @"toro", @"squarepusher"][control.selectedSegmentIndex];
    imageView.image = [UIImage imageNamed:image];
    
    NSLog(@"found %d face(s)",imageView.numberOfFacesDetected);
}

- (void) changeWidth:(UISlider *)slider
{
	imageView.frame = CGRectMake(10, CGRectGetMaxY(controlsView.frame), slider.value, imageView.frame.size.height);
}

- (void) changeHeight:(UISlider *)slider
{
	imageView.frame = CGRectMake(10, CGRectGetMaxY(controlsView.frame), imageView.frame.size.width, slider.value);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
