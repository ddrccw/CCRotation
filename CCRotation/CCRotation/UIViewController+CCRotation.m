//
//  UIViewController+ CCRotation.m
//   
//
//  Created by ddrccw on 15-3-30.
//  Copyright (c) 2015年 ddrccw. All rights reserved.
//

#import "UIViewController+CCRotation.h"
#import <objc/runtime.h>
#import <EXTScope.h>

static const char kMotionManagerKey;
static const char kMotionQueueKey;
static const char kRealDeviceOrientationKey;
static const char kRotationDelegateKey;
static const char kNotfirstRotaitonDetectionKey;

@implementation UIViewController (CCRotation)

- (CMMotionManager *)motionManager {
    return objc_getAssociatedObject(self, &kMotionManagerKey);
}

- (void)setMotionManager:(CMMotionManager *)motionManager {
    objc_setAssociatedObject(self, &kMotionManagerKey, motionManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSOperationQueue *)motionQueue {
    return objc_getAssociatedObject(self, &kMotionQueueKey);
}

- (void)setMotionQueue:(NSOperationQueue *)motionQueue {
    objc_setAssociatedObject(self, &kMotionQueueKey, motionQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIDeviceOrientation)realDeviceOrientation {
    return [objc_getAssociatedObject(self, &kRealDeviceOrientationKey) integerValue] ;
}

- (void)setRealDeviceOrientation:(UIDeviceOrientation)realDeviceOrientation {
    objc_setAssociatedObject(self, &kRealDeviceOrientationKey, @(realDeviceOrientation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id< CCViewControllerRotationDelegate>)rotationDelegate {
    return objc_getAssociatedObject(self, &kRotationDelegateKey);
}

- (void)setRotationDelegate:(id< CCViewControllerRotationDelegate>)rotationDelegate {
    objc_setAssociatedObject(self, &kRotationDelegateKey, rotationDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)notfirstRotaitonDetection {
    return [objc_getAssociatedObject(self, &kNotfirstRotaitonDetectionKey) boolValue] ;
}

- (void)setNotfirstRotaitonDetection:(BOOL)notfirstRotaitonDetection {
    objc_setAssociatedObject(self, &kNotfirstRotaitonDetectionKey, @(notfirstRotaitonDetection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)startRotationDectecting {
    int seconds = 0;
    if (!self.notfirstRotaitonDetection && [self.rotationDelegate respondsToSelector:@selector(preferredDelayedTimeOfRealDeviceOrientationDetection)]) {
        seconds = [self.rotationDelegate preferredDelayedTimeOfRealDeviceOrientationDetection];
        self.notfirstRotaitonDetection = YES;
    }
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC));
    dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
        if (!self.motionManager) {
            self.motionManager = [[CMMotionManager alloc] init];
            self.motionManager.deviceMotionUpdateInterval = 0.1; // 10 Hz
            self.realDeviceOrientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
            self.motionQueue = [[NSOperationQueue alloc] init];
            self.motionQueue.name = NSStringFromClass(self.class);
        }
        
        @weakify(self);
        if ([self.motionManager isDeviceMotionAvailable] && ![self.motionManager isDeviceMotionActive]) {
            [self.motionManager startDeviceMotionUpdatesToQueue:self.motionQueue
                                                    withHandler:^(CMDeviceMotion *motion, NSError *error)
             {
                 @strongify(self);
                 double x = motion.gravity.x;
                 double y = motion.gravity.y;
                 UIDeviceOrientation orientation = self.realDeviceOrientation;
                 static CGFloat kFactor = 0.45;  //should be less then 1
                 if (fabs(y) >= fabs(x))
                 {
                     if (y >= kFactor) {
                         if (self.realDeviceOrientation != UIDeviceOrientationPortraitUpsideDown) {
                             self.realDeviceOrientation = UIDeviceOrientationPortraitUpsideDown;
                             if (([self.rotationDelegate respondsToSelector:@selector(supportedRealDeviceOrientationDetection)] &&
                                  [self.rotationDelegate supportedRealDeviceOrientationDetection]) &&
                                 [self.rotationDelegate respondsToSelector:@selector(realDeviceOrientationDidChangeFromDeviceOrientation:)])
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [self.rotationDelegate realDeviceOrientationDidChangeFromDeviceOrientation:orientation];
                                 });
                             }
                         }
                     }
                     else if (y < -kFactor) {
                         if (self.realDeviceOrientation != UIDeviceOrientationPortrait) {
                             self.realDeviceOrientation = UIDeviceOrientationPortrait;
                             if (([self.rotationDelegate respondsToSelector:@selector(supportedRealDeviceOrientationDetection)] &&
                                  [self.rotationDelegate supportedRealDeviceOrientationDetection]) &&
                                 [self.rotationDelegate respondsToSelector:@selector(realDeviceOrientationDidChangeFromDeviceOrientation:)])
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [self.rotationDelegate realDeviceOrientationDidChangeFromDeviceOrientation:orientation];
                                 });
                             }
                         }
                     }
                 }
                 else
                 {
                     if (x >= kFactor) {
                         if (self.realDeviceOrientation != UIDeviceOrientationLandscapeRight) {
                             self.realDeviceOrientation = UIDeviceOrientationLandscapeRight;
                             if (([self.rotationDelegate respondsToSelector:@selector(supportedRealDeviceOrientationDetection)] &&
                                  [self.rotationDelegate supportedRealDeviceOrientationDetection]) &&
                                 [self.rotationDelegate respondsToSelector:@selector(realDeviceOrientationDidChangeFromDeviceOrientation:)])
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [self.rotationDelegate realDeviceOrientationDidChangeFromDeviceOrientation:orientation];
                                 });
                             }
                         }
                         
                     }
                     else if (x < -kFactor) {
                         if (self.realDeviceOrientation != UIDeviceOrientationLandscapeLeft) {
                             self.realDeviceOrientation = UIDeviceOrientationLandscapeLeft;
                             if (([self.rotationDelegate respondsToSelector:@selector(supportedRealDeviceOrientationDetection)] &&
                                  [self.rotationDelegate supportedRealDeviceOrientationDetection]) &&
                                 [self.rotationDelegate respondsToSelector:@selector(realDeviceOrientationDidChangeFromDeviceOrientation:)])
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [self.rotationDelegate realDeviceOrientationDidChangeFromDeviceOrientation:orientation];
                                 });
                             }
                         }
                     }
                 }
             }];
        }
    });
}

- (void)stopRotationDectecting {
    if ([self.motionManager isDeviceMotionActive]) {
        [self.motionManager stopDeviceMotionUpdates];
    }
}

@end
