//
//  HoloTargteExceptionProtocol.h
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoloTargteExceptionProtocol <NSObject>

- (void)holo_registFailedForTarget:(Class)target withProtocol:(Protocol *)protocol;

- (void)holo_registFailedForTarget:(Class)target withUrl:(NSString *)url;

- (void)holo_matchFailedWithProtocol:(Protocol *)protocol;

- (void)holo_matchFailedWithUrl:(NSString *)url;

- (void)holo_unrecognizedSelectorSentToTarget:(Class)target selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
