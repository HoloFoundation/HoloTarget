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
    if ([target isKindOfClass:UIViewController.class]) {
        return target;
    } else if (target) {
        if ([HoloTarget sharedInstance].exceptionProxy && [[HoloTarget sharedInstance] respondsToSelector:@selector(holo_matchFailedWithProtocol:)]) {
            [[HoloTarget sharedInstance].exceptionProxy holo_matchFailedWithProtocol:protocol];
        }
        HoloLog(@"[HoloTarget] Match failed because the target (%@) is not kind of UIViewController, with the protocol (%@).", [target class], NSStringFromProtocol(protocol));
    }
    return nil;
}

+ (nullable UIViewController *)matchViewControllerWithUrl:(NSString *)url {
    id target = [[HoloTarget sharedInstance] matchTargetInstanceWithUrl:url];
    if ([target isKindOfClass:UIViewController.class]) {
        NSDictionary *targetParams = [url holo_targetUrlParams];
        if (targetParams) {
            objc_setAssociatedObject(target, &KHoloNavigatorParamsKey, targetParams, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        return target;
    } else if (target) {
       if ([HoloTarget sharedInstance].exceptionProxy && [[HoloTarget sharedInstance] respondsToSelector:@selector(holo_matchFailedWithUrl:)]) {
           [[HoloTarget sharedInstance].exceptionProxy holo_matchFailedWithUrl:url];
       }
        HoloLog(@"[HoloTarget] Match failed because the target (%@) is not kind of UIViewController, with the url (%@).", [target class], url);
    }
    return nil;
}

+ (NSDictionary *)matchUrlParamsWithViewController:(UIViewController *)viewController {
    return objc_getAssociatedObject(viewController, &KHoloNavigatorParamsKey);
}

@end
