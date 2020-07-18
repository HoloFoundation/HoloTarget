//
//  NSObject+HoloTargetUnrecognizedSelector.h
//  HoloTarget
//
//  Created by Honglou Gong on 2020/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HoloTargetUnrecognizedSelector)

+ (void)holo_protectUnrecognizedSelector;

- (void)holo_protectUnrecognizedSelector;

@end

NS_ASSUME_NONNULL_END
