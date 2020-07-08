//
//  HoloTarget.h
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/25.
//

#import <Foundation/Foundation.h>
#import "HoloNavigator.h"
#import "HoloTargteDelegate.h"
#import "NSString+HoloTargetUrlParser.h"
#import "HoloTargetMacro.h"
#import "HoloBaseTarget.h"
#import "HoloBaseTargetViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HoloTarget : NSObject

/// 单例实现方法
+ (instancetype)sharedInstance;

/// 代理 (web viewcontroller 及 exception)
@property (nonatomic, weak) id<HoloTargteDelegate> delegate;

/// 业务 scheme, 用于判断 url scheme 控制跳转
@property (nonatomic, copy) NSString *businessScheme;

/// 获取各个 Pod 内的 holo_target.yaml 文件进行注册 protocol 和 url
- (void)registAllTargetsFromYAML;

/// 根据 protocol 注册 target 类
- (BOOL)registTarget:(Class)target withProtocol:(Protocol *)protocol;

/// 根据 url 注册 target 类
- (BOOL)registTarget:(Class)target withUrl:(NSString *)url;

/// 根据 protocol 匹配 target 类
- (nullable Class)matchTargetWithProtocol:(Protocol *)protocol;

/// 根据 url 匹配 target 类
- (nullable Class)matchTargetWithUrl:(NSString *)url;

/// 根据 protocol 匹配 target 实例
- (nullable id)matchTargetInstanceWithProtocol:(Protocol *)protocol;

/// 根据 url 匹配 target 实例
- (nullable id)matchTargetInstanceWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
