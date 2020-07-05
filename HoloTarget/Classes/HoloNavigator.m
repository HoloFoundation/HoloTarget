//
//  HoloNavigator.m
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/17.
//

#import "HoloNavigator.h"
#import <objc/runtime.h>
#import "HoloTarget.h"
#import "HoloTargetMacro.h"
#import "NSString+HoloTargetUrlParser.h"

static char KHoloNavigatorParamsKey;

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
        if ([HoloTarget sharedInstance].exceptionProxy && [[HoloTarget sharedInstance] respondsToSelector:@selector(holo_matchFailedBecauseNotViewContollerWithTheProtocol:)]) {
            [[HoloTarget sharedInstance].exceptionProxy holo_matchFailedBecauseNotViewContollerWithTheProtocol:protocol];
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
        NSDictionary *targetParams = [url holo_targetUrlParams];
        if (targetParams) {
            objc_setAssociatedObject(vc, &KHoloNavigatorParamsKey, targetParams, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        return vc;
    } else if (vc) {
       if ([HoloTarget sharedInstance].exceptionProxy && [[HoloTarget sharedInstance] respondsToSelector:@selector(holo_matchFailedBecauseNotViewContollerWithTheProtocol:)]) {
           [[HoloTarget sharedInstance].exceptionProxy holo_matchFailedBecauseNotViewContollerWithTheUrl:url];
       } else {
           HoloLog(@"match failed because the target (%@) is not kind of UIViewController", NSStringFromClass(target));
       }
    }
    return nil;
}

- (NSDictionary *)matchUrlParamsWithViewController:(UIViewController *)viewController {
    return objc_getAssociatedObject(viewController, &KHoloNavigatorParamsKey);
}

@end
