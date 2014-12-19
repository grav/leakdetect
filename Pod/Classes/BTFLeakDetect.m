//
//  Created by Mikkel Gravgaard on 12/19/2014.
//  Copyright (c) 2014 Mikkel Gravgaard. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "BTFLeakDetect.h"

static BOOL ThrowException = NO;

@implementation NSObject (Swizzling)
+ (void)swizzle:(SEL)originalSelector with:(SEL)newSelector
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

void checkIfNil(__weak id obj, NSInteger seconds){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(ThrowException){
            NSCAssert(obj == nil, @"%@ is still alive",obj);
        } else {
            if(obj!=nil) NSLog(@"**** %@ is still alive ****",obj);
        };

    });

}

- (void)sw_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {

    __weak UIViewController *vc = self.presentedViewController;
    checkIfNil(vc, 2);
    [self sw_dismissViewControllerAnimated:flag completion:completion];
}
@end

@implementation UINavigationController (Swizzled)
- (UIViewController *)sw_popViewControllerAnimated:(BOOL)animated {
    __weak UIViewController *vc = [self.viewControllers lastObject];
    checkIfNil(vc, 2);
    return [self sw_popViewControllerAnimated:animated];
}
@end
#pragma clang diagnostic pop


@implementation BTFLeakDetect {

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
    [UINavigationController swizzle:@selector(popViewControllerAnimated:) with:@selector(sw_popViewControllerAnimated:)];
    [UIViewController swizzle:@selector(dismissViewControllerAnimated:completion:) with:@selector(sw_dismissViewControllerAnimated:completion:)];

}

@end