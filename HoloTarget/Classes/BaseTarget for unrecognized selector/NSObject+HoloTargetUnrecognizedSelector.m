//
//  NSObject+HoloTargetUnrecognizedSelector.m
//  HoloTarget
//
//  Created by Honglou Gong on 2020/7/6.
//

#import "NSObject+HoloTargetUnrecognizedSelector.h"
#import <objc/runtime.h>
#import "HoloTarget.h"

@implementation HoloTargetStubProxy

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod([self class], sel, imp_implementationWithBlock(^{
        // 收集堆栈, 上报 Crash
        HoloLog(@"[HoloTarget] Unrecognized selector (%@)", NSStringFromSelector(sel));
        
//        if ([HoloTarget sharedInstance].exceptionProxy &&
//            [[HoloTarget sharedInstance].exceptionProxy respondsToSelector:@selector(holo_unrecognizedSelectorSentToTarget:selector:)]) {
//            [[HoloTarget sharedInstance].exceptionProxy holo_unrecognizedSelectorSentToTarget: selector:sel];
//        }
    }), "v@:");
    // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    return YES;
}

@end

@implementation NSObject (HoloTargetUnrecognizedSelector)

+ (void)holo_setupUnrecognizedSelectorStubProxy {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(forwardingTargetForSelector:);
        SEL swizzledSelector = @selector(_holo_forwardingTargetForSelector:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (id)_holo_forwardingTargetForSelector:(SEL)aSelector {
    // Aspects hook 会有问题：动态交换了 forwardInvocation: 方法 (aspect_swizzleForwardInvocation)
    // 问题：怎么判断某个方法被 hook 过了 ?
    // 判断 'forwardingTargetForSelector:'、'resolveInstanceMethod:'、'forwardInvocation:' 被处理过了的话，直接 return nil.
    
    // 自己要处理的话, 直接返回
    if ([self _holo_methodHasOverwrited:@selector(resolveInstanceMethod:) cls:self.class]) {
        return nil;
    }
    if ([self _holo_methodHasOverwrited:@selector(forwardInvocation:) cls:self.class]) {
        return nil;
    }
    return [HoloTargetStubProxy new];
}

// 判断 cls 是否重写了 sel 方法, 递归调用判断父类但不包括 NSObject
- (BOOL)_holo_methodHasOverwrited:(SEL)sel cls:(Class)cls {
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        if (method_getName(method) == sel) {
            free(methods);
            return YES;
        }
    }
    free(methods);
    
    if ([cls superclass] != [NSObject class]) {
        return [self _holo_methodHasOverwrited:sel cls:[cls superclass]];
    }
    return NO;
}

@end
