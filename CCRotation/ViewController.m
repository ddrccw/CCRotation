//
//  ViewController.m
//  CCRotation
//
//  Created by ddrccw on 15/6/24.
//  Copyright (c) 2015年 ddrccw. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+CCRotation.h"

@interface ViewController () <CCViewControllerRotationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ViewController

- (void)dealloc {
    [self stopRotationDectecting];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startRotationDectecting];
    self.rotationDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)supportedRealDeviceOrientationDetection {
    return YES;
}

- (void)realDeviceOrientationDidChangeFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    UIDeviceOrientation currentDeviceOrientation = self.realDeviceOrientation;
    if (currentDeviceOrientation == UIDeviceOrientationPortrait) {
        self.statusLabel.text = @"UIDeviceOrientationPortrait";
    }
    else if (currentDeviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        self.statusLabel.text = @"UIDeviceOrientationPortraitUpsideDown";
    }
    else if (currentDeviceOrientation == UIDeviceOrientationLandscapeLeft) {
        self.statusLabel.text = @"UIDeviceOrientationLandscapeLeft";
    }
    else if (currentDeviceOrientation == UIDeviceOrientationLandscapeRight) {
        self.statusLabel.text = @"UIDeviceOrientationLandscapeRight";
    }
    else {
        self.statusLabel.text = @"UIDeviceOrientationUnknown";
    }
}

@end
