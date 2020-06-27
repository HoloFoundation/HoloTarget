//
//  HoloTargteExceptionProtocol.h
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoloTargteExceptionProtocol <NSObject>

- (void)registFailedBecauseAlreadyRegistTheProtocol:(Protocol *)protocol forTarget:(Class)target;

- (void)registFailedBecauseConnotConformTheProtocol:(Protocol *)protocol forTarget:(Class)target;

- (void)registFailedBecauseAlreadyRegistTheUrl:(NSString *)url forTarget:(Class)target;

- (void)matchFailedBecauseNotRegistTheProtocol:(Protocol *)protocol;

- (void)matchFailedBecauseNotRegistTheUrl:(NSString *)url;

- (void)matchFailedBecauseNotViewContollerWithTheProtocol:(Protocol *)protocol;

- (void)matchFailedBecauseNotViewContollerWithTheUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
