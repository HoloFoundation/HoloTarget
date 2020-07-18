//
//  NSObject+HoloTargetUnrecognizedSelector.m
//  HoloTarget
//
//  Created by Honglou Gong on 2020/7/6.
//

#import "NSObject+HoloTargetUnrecognizedSelector.h"
#import <objc/runtime.h>
#import "HoloTarget.h"

static NSString *const HoloTargetSubclassSuffix = @"_holoTarget_";

static NSString *const HoloTargetForwardInvocationSelectorName = @"__holoTarget_forwardInvocation:";

@implementation NSObject (HoloTargetUnrecognizedSelector)

// 判断 cls 是否重写了 sel 方法, 递归调用判断父类但不包括 NSObject
static BOOL _holo_methodHasOverwrited(Class cls, SEL sel) {
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
        return _holo_methodHasOverwrited([cls superclass], sel);
    }
    return NO;
}

static Class holoTarget_hookClass(NSObject *self) {
    NSCParameterAssert(self);
    Class statedClass = self.class;
    Class baseClass = object_getClass(self);
    NSString *className = NSStringFromClass(baseClass);
    
    // Already subclassed
    if ([className hasSuffix:HoloTargetSubclassSuffix]) {
        return baseClass;
        
        // We swizzle a class object, not a single object.
    }else if (class_isMetaClass(baseClass)) {
        return holoTarget_swizzleClassInPlace((Class)self);
        // Probably a KVO'ed class. Swizzle in place. Also swizzle meta classes in place.
    }else if (statedClass != baseClass) {
        return holoTarget_swizzleClassInPlace(baseClass);
    }
    
    // Default case. Create dynamic subclass.
    const char *subclassName = [className stringByAppendingString:HoloTargetSubclassSuffix].UTF8String;
    Class subclass = objc_getClass(subclassName);
    
    if (subclass == nil) {
        subclass = objc_allocateClassPair(baseClass, subclassName, 0);
        if (subclass == nil) {
            HoloLog(@"[HoloTarget] objc_allocateClassPair failed to allocate class %s.", subclassName);
            return nil;
        }
        
        holoTarget_swizzleForwardInvocation(subclass);
        holoTarget_hookedGetClass(subclass, statedClass);
        holoTarget_hookedGetClass(object_getClass(subclass), statedClass);
        objc_registerClassPair(subclass);
    }
    
    object_setClass(self, subclass);
    return subclass;
}

static Class holoTarget_swizzleClassInPlace(Class klass) {
    NSCParameterAssert(klass);
    NSString *className = NSStringFromClass(klass);
    
    holoTarget_modifySwizzledClasses(^(NSMutableSet *swizzledClasses) {
        if (![swizzledClasses containsObject:className]) {
            holoTarget_swizzleForwardInvocation(klass);
            [swizzledClasses addObject:className];
        }
    });
    return klass;
}

static void holoTarget_modifySwizzledClasses(void (^block)(NSMutableSet *swizzledClasses)) {
    static NSMutableSet *swizzledClasses;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        swizzledClasses = [NSMutableSet new];
    });
    @synchronized(swizzledClasses) {
        block(swizzledClasses);
    }
}

static void holoTarget_swizzleForwardInvocation(Class klass) {
    NSCParameterAssert(klass);
    // If there is no method, replace will act like class_addMethod.
    IMP originalImplementation = class_replaceMethod(klass, @selector(forwardInvocation:), (IMP)__holoTarget_forwardInvocation__, "v@:@");
    if (originalImplementation) {
        class_addMethod(klass, NSSelectorFromString(HoloTargetForwardInvocationSelectorName), originalImplementation, "v@:@");
    }
}

static void holoTarget_hookedGetClass(Class class, Class statedClass) {
    NSCParameterAssert(class);
    NSCParameterAssert(statedClass);
    Method method = class_getInstanceMethod(class, @selector(class));
    IMP newIMP = imp_implementationWithBlock(^(id self) {
        return statedClass;
    });
    class_replaceMethod(class, @selector(class), newIMP, method_getTypeEncoding(method));
}

static void __holoTarget_forwardInvocation__(__unsafe_unretained NSObject *self, SEL selector, NSInvocation *invocation) {
    HoloLog(@"[HoloTarget] *** Caught exception 'NSInvalidArgumentException', reason: '-[%@ %@]: unrecognized selector sent to instance %p'", [self class], NSStringFromSelector(selector), self);
    
    if ([HoloTarget sharedInstance].delegate &&
        [[HoloTarget sharedInstance].delegate respondsToSelector:@selector(holo_unrecognizedSelectorSentToTarget:selector:)]) {
        [[HoloTarget sharedInstance].delegate holo_unrecognizedSelectorSentToTarget:self selector:selector];
    }
}

+ (void)holo_protectUnrecognizedSelector {
    if (_holo_methodHasOverwrited(self, @selector(forwardInvocation:))) {
        return;
    }
    holoTarget_hookClass((id)self);
}

- (void)holo_protectUnrecognizedSelector {
    if (_holo_methodHasOverwrited(self.class, @selector(forwardInvocation:))) {
        return;
    }
    holoTarget_hookClass(self);
}

@end
