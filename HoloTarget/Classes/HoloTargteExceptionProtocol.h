//
//  HoloTargteExceptionProtocol.h
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoloTargteExceptionProtocol <NSObject>

- (void)holo_registFailedBecauseAlreadyRegistTheProtocol:(Protocol *)protocol forTarget:(Class)target;

- (void)holo_registFailedBecauseConnotConformTheProtocol:(Protocol *)protocol forTarget:(Class)target;

- (void)holo_registFailedBecauseAlreadyRegistTheUrl:(NSString *)url forTarget:(Class)target;

- (void)holo_matchFailedBecauseNotRegistTheProtocol:(Protocol *)protocol;

- (void)holo_matchFailedBecauseNotRegistTheUrl:(NSString *)url;

- (void)holo_matchFailedBecauseNotViewContollerWithTheProtocol:(Protocol *)protocol;

- (void)holo_matchFailedBecauseNotViewContollerWithTheUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
