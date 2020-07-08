//
//  HoloNavigator.m
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/17.
//

#import "HoloNavigator.h"
#import <objc/runtime.h>
#import "HoloTarget.h"

static char KHoloNavigatorParamsKey;

@implementation HoloNavigator

+ (nullable UIViewController *)matchViewControllerWithProtocol:(Protocol *)protocol {
    id target = [[HoloTarget sharedInstance] matchTargetInstanceWithProtocol:protocol];
    if (target && [target isKindOfClass:UIViewController.class]) {
        return target;
    } else if (target) {
        if ([HoloTarget sharedInstance].delegate && [[HoloTarget sharedInstance] respondsToSelector:@selector(holo_matchFailedWithProtocol:)]) {
            [[HoloTarget sharedInstance].delegate holo_matchFailedWithProtocol:protocol];
        }
        HoloLog(@"[HoloTarget] Match failed because the target (%@) is not kind of UIViewController, with the protocol (%@).", [target class], NSStringFromProtocol(protocol));
    }
    return nil;
}

+ (nullable UIViewController *)matchViewControllerWithUrl:(NSString *)url {
    NSString *scheme = [url holo_targetUrlScheme];
    
    // web viewcontroller
    if ([scheme.lowercaseString isEqualToString:@"http"] || [scheme.lowercaseString isEqualToString:@"https"]) {
        if ([HoloTarget sharedInstance].delegate && [[HoloTarget sharedInstance] respondsToSelector:@selector(holo_matchWebViewControllerWithUrl:)]) {
            UIViewController *webVC = [[HoloTarget sharedInstance].delegate holo_matchWebViewControllerWithUrl:url];
            return webVC;
        }
    }
    
    // 约定必须遵守 business scheme 才可进行路由
    if ([HoloTarget sharedInstance].businessScheme.length > 0 && ![scheme isEqualToString:[HoloTarget sharedInstance].businessScheme]) {
        return nil;
    }
    
    id target = [[HoloTarget sharedInstance] matchTargetInstanceWithUrl:url];
    if (target && [target isKindOfClass:UIViewController.class]) {
        NSDictionary *params = [url holo_targetUrlParams];
        if (params) {
            objc_setAssociatedObject(target, &KHoloNavigatorParamsKey, params, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        return target;
    } else if (target) {
       if ([HoloTarget sharedInstance].delegate && [[HoloTarget sharedInstance] respondsToSelector:@selector(holo_matchFailedWithUrl:)]) {
           [[HoloTarget sharedInstance].delegate holo_matchFailedWithUrl:url];
       }
        HoloLog(@"[HoloTarget] Match failed because the target (%@) is not kind of UIViewController, with the url (%@).", [target class], url);
    }
    return nil;
}

+ (NSDictionary *)matchUrlParamsWithViewController:(UIViewController *)viewController {
    return objc_getAssociatedObject(viewController, &KHoloNavigatorParamsKey);
}

@end
