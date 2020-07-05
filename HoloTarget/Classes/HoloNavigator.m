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

+ (nullable UIViewController *)matchViewControllerWithProtocol:(Protocol *)protocol {
    Class target = [[HoloTarget sharedInstance] matchTargetWithProtocol:protocol];
    UIViewController *vc = [target new];
    if ([vc isKindOfClass:UIViewController.class]) {
        return vc;
    } else if (vc) {
        if ([HoloTarget sharedInstance].exceptionProxy && [[HoloTarget sharedInstance] respondsToSelector:@selector(holo_matchFailedWithProtocol:)]) {
            [[HoloTarget sharedInstance].exceptionProxy holo_matchFailedWithProtocol:protocol];
        }
        HoloLog(@"[HoloTarget] Match failed because the target (%@) is not kind of UIViewController, with the protocol (%@).", target, protocol);
    }
    return nil;
}

+ (nullable UIViewController *)matchViewControllerWithUrl:(NSString *)url {
    Class target = [[HoloTarget sharedInstance] matchTargetWithUrl:url];
    UIViewController *vc = [target new];
    if ([vc isKindOfClass:UIViewController.class]) {
        NSDictionary *targetParams = [url holo_targetUrlParams];
        if (targetParams) {
            objc_setAssociatedObject(vc, &KHoloNavigatorParamsKey, targetParams, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        return vc;
    } else if (vc) {
       if ([HoloTarget sharedInstance].exceptionProxy && [[HoloTarget sharedInstance] respondsToSelector:@selector(holo_matchFailedWithUrl:)]) {
           [[HoloTarget sharedInstance].exceptionProxy holo_matchFailedWithUrl:url];
       }
        HoloLog(@"[HoloTarget] Match failed because the target (%@) is not kind of UIViewController, with the url (%@).", target, url);
    }
    return nil;
}

+ (NSDictionary *)matchUrlParamsWithViewController:(UIViewController *)viewController {
    return objc_getAssociatedObject(viewController, &KHoloNavigatorParamsKey);
}

@end
