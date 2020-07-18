//
//  HoloTargteDelegate.h
//  HoloTarget
//
//  Created by Honglou Gong on 2020/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoloTargteDelegate <NSObject>

/// web viewcontroller
- (UIViewController *)holo_matchWebViewControllerWithUrl:(NSString *)url;

/// exception
- (void)holo_registFailedForTarget:(Class)target withProtocol:(Protocol *)protocol;

- (void)holo_registFailedForTarget:(Class)target withUrl:(NSString *)url;

- (void)holo_matchFailedWithProtocol:(Protocol *)protocol;

- (void)holo_matchFailedWithUrl:(NSString *)url;

- (void)holo_unrecognizedSelectorSentToTarget:(id)target selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
