//
//  HoloTargetDemoAProtocol.h
//  HoloTargetDemoA
//
//  Created by 与佳期 on 2020/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoloTargetDemoAProtocol <NSObject>

- (UIViewController *)viewControllerAWithTitle:(NSString *)title;

- (UIViewController *)viewControllerA2WithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
