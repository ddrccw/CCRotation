//
//  UIViewController+ CCRotation.h
//   
//
//  Created by ddrccw on 15-3-30.
//  Copyright (c) 2015年 ddrccw. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreMotion;

@protocol CCViewControllerRotationDelegate <NSObject>

- (void)realDeviceOrientationDidChangeFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation;

@optional
- (BOOL)supportedRealDeviceOrientationDetection;
- (NSTimeInterval)preferredDelayedTimeOfRealDeviceOrientationDetection;  //初始化时，延迟多少s开始detect，默认是0
@end

@interface UIViewController (CCRotation)
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSOperationQueue *motionQueue;  //for motion detect
@property (assign, nonatomic) UIDeviceOrientation realDeviceOrientation;
@property (weak, nonatomic) id <CCViewControllerRotationDelegate> rotationDelegate;
@property (assign, nonatomic) BOOL notfirstRotaitonDetection;  //初始化用

- (void)startRotationDectecting;
- (void)stopRotationDectecting; //!IMPORTANT: need to be called in dealloc

@end
