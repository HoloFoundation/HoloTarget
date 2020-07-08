//
//  HoloBaseTarget.m
//  HoloTarget
//
//  Created by Honglou Gong on 2020/7/8.
//

#import "HoloBaseTarget.h"
#import <objc/runtime.h>
#import "HoloTarget.h"

@implementation HoloBaseTarget

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod([self class], sel, imp_implementationWithBlock(^{
        HoloLog(@"[HoloTarget] -[%@ %@]: unrecognized selector.", self.class, NSStringFromSelector(sel));
        
        if ([HoloTarget sharedInstance].exceptionProxy &&
            [[HoloTarget sharedInstance].exceptionProxy respondsToSelector:@selector(holo_unrecognizedSelectorSentToTarget:selector:)]) {
            [[HoloTarget sharedInstance].exceptionProxy holo_unrecognizedSelectorSentToTarget:self.class selector:sel];
        }
    }), "v@:");
    return YES;
}

@end
