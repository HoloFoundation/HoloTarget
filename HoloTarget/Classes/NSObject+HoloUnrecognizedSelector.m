//
//  NSObject+HoloUnrecognizedSelector.m
//  HoloTarget
//
//  Created by 与佳期 on 2020/7/5.
//

#import "NSObject+HoloUnrecognizedSelector.h"
#import <objc/runtime.h>
#import "HoloTargetMacro.h"

@implementation HoloTargetStubProxy

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod([self class], sel, imp_implementationWithBlock(^{
        // 收集堆栈, 上报 Crash
        // NSLog(@"%@", [NSThread callStackSymbols]);
        HoloLog(@"[HoloTarget] Error for .");
        return nil;
    }), "@@:");
    return YES;
    
    /*
     2020-07-05 23:00:42.012945+0800 HoloTarget_Example[521:21464229] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[HoloDemoViewControllerA holoDemoViewControllerA:]: unrecognized selector sent to instance 0x7fbb2f71c9c0'
     */
    
    /*
     "@@:" describes a method with returns an object (type encoding @, in your case: UIView *) and takes no arguments apart from the fixed (hidden) arguments self (type encoding @ for object) and _cmd (type encoding : for selector).
     https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
     */
}

@end

@implementation NSObject (HoloUnrecognizedSelector)

//+ (void)load {
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
    // Aspects hook 会有问题：动态交换了 forwardInvocation: 方法 (aspect_swizzleForwardInvocation) !!!
    // 问题：怎么判断 这个方法被处理过了，这里不再处理，直接 return nil
    
    // 如果重写了 'forwardInvocation:', 说明自己要处理, 这里直接返回
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
