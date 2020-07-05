//
//  HoloTargetDemoAMainTarget.h
//  HoloTargetDemoA
//
//  Created by 与佳期 on 2020/7/5.
//

#import <Foundation/Foundation.h>
#import <HoloTargetProtocolPool/HoloTargetProtocolPool.h>

NS_ASSUME_NONNULL_BEGIN

@interface HoloTargetDemoAMainTarget : NSObject <HoloTargetDemoAProtocol>

- (UIViewController *)viewControllerAWithTitle:(NSString *)title;

- (UIViewController *)viewControllerA2WithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
