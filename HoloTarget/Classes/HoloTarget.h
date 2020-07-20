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

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HoloTargetUnrecognizedSelectorGuard) {
    HoloTargetUnrecognizedSelectorGuardNone,
    HoloTargetUnrecognizedSelectorGuardOnline // default
};

@interface HoloTarget : NSObject

/// 单例实现方法
+ (instancetype)sharedInstance;

/// 代理 (web viewcontroller 及 exception)
@property (nonatomic, weak) id<HoloTargteDelegate> delegate;

/// 业务 scheme, 用于判断 url scheme 控制跳转
@property (nonatomic, copy) NSString *businessScheme;

/// Unrecognized Selector 崩溃保护, 默认添加保护
@property (nonatomic, assign) HoloTargetUnrecognizedSelectorGuard unrecognizedSelectorGuard;

/// 获取各个 Pod 内的 holo_target.yaml 配置文件进行注册 protocol 和 url
/// Requirement :  在主工程编译期 (Build Phases) 执行 holo_target_generator.rb 脚本
/// Attention(1):  各个 pod 内创建名为 holo_target.yaml 的配置文件, 格式参见 holo_target_example.yaml
/// Attention(2):  不要将 holo_target.yaml 配置文件存储在 Main Bundle 内, 避免互相覆盖
- (void)registAllTargetsFromYAML;

/// 根据 protocol 注册 target 类
/// @param target   注册类
/// @param protocol 注册协议
/// @return         是否注册成功
- (BOOL)registTarget:(Class)target withProtocol:(Protocol *)protocol;

/// 根据 protocol 注册 target 类
/// @param target   注册类
/// @param protocol 注册协议
/// @param force    覆盖注册
/// @return         是否注册成功
- (BOOL)registTarget:(Class)target withProtocol:(Protocol *)protocol force:(BOOL)force;

/// 根据 url 注册 target 类
/// @param target   注册类
/// @param url      注册链接
/// @return         是否注册成功
- (BOOL)registTarget:(Class)target withUrl:(NSString *)url;

/// 根据 url 注册 target 类
/// @param target   注册类
/// @param url      注册链接
/// @param force    覆盖注册
/// @return         是否注册成功
- (BOOL)registTarget:(Class)target withUrl:(NSString *)url force:(BOOL)force;

/// 根据 protocol 匹配 target 类
/// @param protocol 注册协议
/// @return         匹配到的注册类
- (nullable Class)matchTargetWithProtocol:(Protocol *)protocol;

/// 根据 url 匹配 target 类
/// @param url      注册链接
/// @return         匹配到的注册类
- (nullable Class)matchTargetWithUrl:(NSString *)url;

/// 根据 protocol 匹配 target 实例
/// @param protocol 注册协议
/// @return         匹配到的注册类实例
- (nullable id)matchTargetInstanceWithProtocol:(Protocol *)protocol;

/// 根据 url 匹配 target 实例
/// @param url      注册链接
/// @return         匹配到的注册类实例
- (nullable id)matchTargetInstanceWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
