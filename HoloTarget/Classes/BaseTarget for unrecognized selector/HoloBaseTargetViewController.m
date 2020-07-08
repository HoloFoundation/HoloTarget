//
//  HoloBaseTargetViewController.m
//  HoloTarget
//
//  Created by Honglou Gong on 2020/7/8.
//

#import "HoloBaseTargetViewController.h"
#import <objc/runtime.h>
#import "HoloTarget.h"

@implementation HoloBaseTargetViewController

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod([self class], sel, imp_implementationWithBlock(^{
        HoloLog(@"[HoloTarget] -[%@ %@]: unrecognized selector.", self.class, NSStringFromSelector(sel));
        
        if ([HoloTarget sharedInstance].delegate &&
            [[HoloTarget sharedInstance].delegate respondsToSelector:@selector(holo_unrecognizedSelectorSentToTarget:selector:)]) {
            [[HoloTarget sharedInstance].delegate holo_unrecognizedSelectorSentToTarget:self.class selector:sel];
        }
    }), "v@:");
    return YES;
}

@end
