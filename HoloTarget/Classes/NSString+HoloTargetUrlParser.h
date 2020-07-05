//
//  NSString+HoloTargetUrlParser.h
//  HoloTarget
//
//  Created by 与佳期 on 2020/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HoloTargetUrlParser)

- (NSString *)holo_targetUrlScheme;

- (NSString *)holo_targetUrlPath;

- (NSDictionary *)holo_targetUrlParams;

@end

NS_ASSUME_NONNULL_END
