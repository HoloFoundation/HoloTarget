//
//  HoloNavigator.m
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/17.
//

#import "HoloNavigator.h"
#import "HoloTarget.h"
#import "HoloTargetMacro.h"

@implementation HoloNavigator

+ (instancetype)sharedInstance {
    static HoloNavigator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [HoloNavigator new];
    });
    return sharedInstance;
}

- (nullable UIViewController *)matchViewControllerWithProtocol:(Protocol *)protocol {
    Class target = [[HoloTarget sharedInstance] matchTargetWithProtocol:protocol];
    UIViewController *vc = [target new];
    if ([vc isKindOfClass:UIViewController.class]) {
        return vc;
    } else if (vc) {
        if ([HoloTarget sharedInstance].exceptionProxy && [[HoloTarget sharedInstance] respondsToSelector:@selector(matchFailedBecauseNotViewContollerWithTheProtocol:)]) {
            [[HoloTarget sharedInstance].exceptionProxy matchFailedBecauseNotViewContollerWithTheProtocol:protocol];
        } else {
            HoloLog(@"match failed because the target (%@) is not kind of UIViewController", NSStringFromClass(target));
        }
    }
    return nil;
}

- (nullable UIViewController *)matchViewControllerWithUrl:(NSString *)url {
    Class target = [[HoloTarget sharedInstance] matchTargetWithUrl:url];
    UIViewController *vc = [target new];
    if ([vc isKindOfClass:UIViewController.class]) {
        return vc;
    } else if (vc) {
       if ([HoloTarget sharedInstance].exceptionProxy && [[HoloTarget sharedInstance] respondsToSelector:@selector(matchFailedBecauseNotViewContollerWithTheProtocol:)]) {
           [[HoloTarget sharedInstance].exceptionProxy matchFailedBecauseNotViewContollerWithTheUrl:url];
       } else {
           HoloLog(@"match failed because the target (%@) is not kind of UIViewController", NSStringFromClass(target));
       }
    }
    return nil;
}

@end
