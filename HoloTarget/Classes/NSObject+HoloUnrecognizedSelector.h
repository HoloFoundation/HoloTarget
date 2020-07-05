//
//  NSObject+HoloUnrecognizedSelector.h
//  HoloTarget
//
//  Created by 与佳期 on 2020/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HoloTargetStubProxy : NSObject

@end

@interface NSObject (HoloUnrecognizedSelector)

+ (void)holo_setupUnrecognizedSelectorStubProxy;

@end

NS_ASSUME_NONNULL_END
