//
//  HoloTarget.h
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/25.
//

#import <Foundation/Foundation.h>
#import "HoloTargteExceptionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HoloTarget : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id<HoloTargteExceptionProtocol> exceptionProxy;

- (void)registAllTargetsFromYAML;

- (BOOL)registTarget:(Class)target withProtocol:(Protocol *)protocol;

- (BOOL)registTarget:(Class)target withUrl:(NSString *)url;

- (nullable Class)matchTargetWithProtocol:(Protocol *)protocol;

- (nullable Class)matchTargetWithUrl:(NSString *)url;

- (nullable id)matchTargetInstanceWithProtocol:(Protocol *)protocol;

- (nullable id)matchTargetInstanceWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
