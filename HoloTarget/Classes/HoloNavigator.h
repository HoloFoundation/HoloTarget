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
/// @param protocol 注册协议
/// @return         匹配到的 UIViewController 实例
+ (nullable UIViewController *)matchViewControllerWithProtocol:(Protocol *)protocol;

/// 根据 url 匹配 viewController 实例
/// @param url  注册链接
/// @return     匹配到的 UIViewController 实例
+ (nullable UIViewController *)matchViewControllerWithUrl:(NSString *)url;

/// 根据 viewController 匹配 url 入参
/// @param viewController   根据注册链接匹配到的 UIViewController 实例
/// @return                 注册链接传递的参数
+ (nullable NSDictionary *)matchUrlParamsWithViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
