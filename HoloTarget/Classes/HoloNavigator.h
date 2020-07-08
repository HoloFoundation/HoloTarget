//
//  HoloNavigator.h
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HoloNavigator : NSObject

/// 根据 protocol 匹配 viewController 实例
+ (nullable UIViewController *)matchViewControllerWithProtocol:(Protocol *)protocol;

/// 根据 url 匹配 viewController 实例
+ (nullable UIViewController *)matchViewControllerWithUrl:(NSString *)url;

/// 根据 viewController 匹配 url 入参
+ (nullable NSDictionary *)matchUrlParamsWithViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
