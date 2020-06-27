//
//  HoloDemoViewControllerAProtocol.h
//  HoloTargetProtocolPool
//
//  Created by 与佳期 on 2020/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoloDemoViewControllerAProtocol <NSObject>

- (void)holoDemoViewControllerA:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
