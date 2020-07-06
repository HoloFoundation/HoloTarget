//
//  NSObject+HoloTargetUnrecognizedSelector.m
//  HoloTarget
//
//  Created by Honglou Gong on 2020/7/6.
//

#import "NSObject+HoloTargetUnrecognizedSelector.h"
#import <objc/runtime.h>
#import "HoloTargetMacro.h"
#import "HoloTarget.h"

@implementation HoloTargetStubProxy

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    class_addMethod([self class], sel, imp_implementationWithBlock(^{
        // 收集堆栈, 上报 Crash
//        HoloLog(@"-[HoloDemoViewControllerA holoDemoViewControllerA:]: unrecognized selector sent to instance 0x7fbb2f71c9c0");
//
//        if ([HoloTarget sharedInstance].exceptionProxy &&
//            [[HoloTarget sharedInstance].exceptionProxy respondsToSelector:@selector(holo_unrecognizedSelectorSentToTarget:selector:)]) {
//            [[HoloTarget sharedInstance].exceptionProxy holo_unrecognizedSelectorSentToTarget:self selector:sel];
//        }
    }), "v@:");
    return YES;
}

@end

@implementation NSObject (HoloTargetUnrecognizedSelector)

+ (void)holo_setupUnrecognizedSelectorStubProxy {
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
}

- (id)_holo_forwardingTargetForSelector:(SEL)aSelector {
    // Aspects hook 会有问题：动态交换了 forwardInvocation: 方法 (aspect_swizzleForwardInvocation) !!!
    // 问题：怎么判断 这个方法被处理过了，这里不再处理，直接 return nil ?
    
    // 自己要处理的话, 直接返回
    if ([self _holo_methodHasOverwrited:@selector(resolveInstanceMethod:) cls:self.class]) {
        return nil;
    }
    if ([self _holo_methodHasOverwrited:@selector(forwardInvocation:) cls:self.class]) {
        return nil;
    }
    return [HoloTargetStubProxy new];
}

// 判断 cls 是否重写了 sel 方法, 递归调用判断但不包括 NSObject
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
    
    // 可能父类实现了这个 sel, 一直遍历到基类 NSObject 为止
    if ([cls superclass] != [NSObject class]) {
        return [self _holo_methodHasOverwrited:sel cls:[cls superclass]];
    }
    return NO;
}

@end