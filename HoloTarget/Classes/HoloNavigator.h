//
//  HoloNavigator.h
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HoloNavigator : NSObject

+ (instancetype)sharedInstance;

- (nullable UIViewController *)matchViewControllerWithProtocol:(Protocol *)protocol;

- (nullable UIViewController *)matchViewControllerWithUrl:(NSString *)url;

- (nullable NSDictionary *)matchUrlParamsWithViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
