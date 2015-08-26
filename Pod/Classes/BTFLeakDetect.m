//
//  Created by Mikkel Gravgaard on 12/19/2014.
//  Copyright (c) 2014 Mikkel Gravgaard. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "BTFLeakDetect.h"

@interface BTFLeakDetect (Private)
+ (void)checkViewController:(__weak UIViewController *)vc;
@end

static BOOL ThrowException = NO;

void checkIfNil(__weak id obj, NSInteger seconds);

@implementation NSObject (Swizzling)
+ (void)btf_swizzle:(SEL)originalSelector with:(SEL)newSelector
{
    Class aClass = [self class];
    Method origMethod = class_getInstanceMethod(aClass, originalSelector);
    Method newMethod = class_getInstanceMethod(aClass, newSelector);

    if(class_addMethod(aClass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(aClass, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }

}
@end

@implementation UIViewController (Swizzled)
#pragma clang diagnostic push
#pragma ide diagnostic ignored "InfiniteRecursion"


- (void)btf_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {

    UIViewController *dismissVC = self.presentedViewController ?: self;
    [BTFLeakDetect checkViewController:dismissVC];

    [self btf_dismissViewControllerAnimated:flag completion:completion];
}
@end

@implementation UINavigationController (Swizzled)
- (UIViewController *)btf_popViewControllerAnimated:(BOOL)animated {

    [BTFLeakDetect checkViewController:[self.viewControllers lastObject]];

    return [self btf_popViewControllerAnimated:animated];
}
@end
#pragma clang diagnostic pop

void checkIfNil(__weak id obj, NSInteger seconds){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(ThrowException){
            NSCAssert(obj == nil, @"%@ is still alive",obj);
        } else {
            if(obj!=nil) NSLog(@"**** %@ is still alive ****",obj);
        };

    });

}

@implementation BTFLeakDetect {

}

+ (void)checkViewController:(__weak UIViewController *)vc
{
    NSMutableSet *vcs = [NSMutableSet setWithObject:vc];

    if([vc isKindOfClass:[UINavigationController class]]){
        UINavigationController *nvc = (UINavigationController *) vc;
        [vcs addObjectsFromArray:nvc.viewControllers];
    }
    [vcs addObjectsFromArray:vc.childViewControllers];

    for(UIViewController *cvc in vcs){
        checkIfNil(cvc, 2);
    }

}

+ (void)enableWithLogging
{
    ThrowException = NO;
    [self enable];
}

+ (void)enableWithException {
    ThrowException = YES;
    [self enable];
}

+ (void)enable{
    [UINavigationController btf_swizzle:@selector(popViewControllerAnimated:) with:@selector(btf_popViewControllerAnimated:)];
    [UIViewController btf_swizzle:@selector(dismissViewControllerAnimated:completion:) with:@selector(btf_dismissViewControllerAnimated:completion:)];

}

@end