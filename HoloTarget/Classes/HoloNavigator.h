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

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
//
//- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated;
//
//- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
//
//- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated;
//
//
//- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
//
//- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion;


- (nullable UIViewController *)matchViewControllerWithProtocol:(Protocol *)protocol;

- (nullable UIViewController *)matchViewControllerWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
