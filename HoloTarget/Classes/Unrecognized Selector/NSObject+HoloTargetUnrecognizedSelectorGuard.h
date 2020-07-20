//
//  NSObject+HoloTargetUnrecognizedSelectorGuard.h
//  HoloTarget
//
//  Created by Honglou Gong on 2020/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HoloTargetUnrecognizedSelectorGuard)

+ (void)holo_setupUnrecognizedSelectorGuard;

- (void)holo_setupUnrecognizedSelectorGuard;

@end

NS_ASSUME_NONNULL_END
