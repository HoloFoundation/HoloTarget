//
//  HoloTarget.m
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/25.
//

#import "HoloTarget.h"
#import <YAML-Framework/YAMLSerialization.h>

@interface HoloTarget ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *targetMap;

@end

@implementation HoloTarget

+ (instancetype)sharedInstance {
    static HoloTarget *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [HoloTarget new];
    });
    return sharedInstance;
}

- (void)registAllTargetsFromYAML {
    NSString *path = [[NSBundle mainBundle] pathForResource:@".HOLO_ALL_TARGETS" ofType:@"yaml"];
    NSInputStream *stream = [[NSInputStream alloc] initWithFileAtPath:path];
    NSDictionary *yaml = [YAMLSerialization objectWithYAMLStream:stream
                                                         options:kYAMLReadOptionStringScalars
                                                           error:nil];
    
    if (![yaml isKindOfClass:NSDictionary.class]) {
        HoloLog(@"[HoloTarget] Error for some one 'holo_target.yaml'.");
        return;
    }
    
    __block BOOL isSuccess = YES;
    
    [yaml enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull cls, NSDictionary * _Nonnull dict, BOOL * _Nonnull stop) {
        
        if (![cls isKindOfClass:NSString.class] || ![dict isKindOfClass:NSDictionary.class]) {
            isSuccess = NO;
            return;
        }
        
        NSArray<NSString *> *urls = dict[@"urls"];
        if ([urls isKindOfClass:NSArray.class]) {
            [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([url isKindOfClass:NSString.class]) {
                    [self registTarget:NSClassFromString(cls) withUrl:url];
                } else {
                    isSuccess = NO;
                }
            }];
        } else if (urls) {
            isSuccess = NO;
        }
        
        NSArray<NSString *> *protocols = dict[@"protocols"];
        if ([protocols isKindOfClass:NSArray.class]) {
            [protocols enumerateObjectsUsingBlock:^(NSString * _Nonnull protocol, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([protocol isKindOfClass:NSString.class]) {
                    [self registTarget:NSClassFromString(cls) withProtocol:NSProtocolFromString(protocol)];
                } else {
                    isSuccess = NO;
                }
            }];
        } else if (protocols) {
            isSuccess = NO;
        }
        
    }];
    
    if (!isSuccess) {
        HoloLog(@"[HoloTarget] Error for some one 'holo_target.yaml'.");
    }
}

- (BOOL)registTarget:(Class)target withProtocol:(Protocol *)protocol {
    BOOL isSuccess = YES;
    
    NSString *protocolString = NSStringFromProtocol(protocol);
    if (!target || !protocolString) {
        HoloLog(@"[HoloTarget] Regist failed because the target (%@) or the protocol (%@) is nil.", target, protocolString);
        isSuccess = NO;
    } else if (self.targetMap[protocolString]) {
        HoloLog(@"[HoloTarget] Regist failed because the protocol (%@) was already registered.", protocolString);
        isSuccess = NO;
    } else if (![target conformsToProtocol:protocol]) {
        HoloLog(@"[HoloTarget] Regist failed because the target (%@) is not conform to the protocol (%@).", target, protocolString);
        isSuccess = NO;
    }
    
    if (!isSuccess) {
        if (self.exceptionProxy && [self.exceptionProxy respondsToSelector:@selector(holo_registFailedForTarget:withProtocol:)]) {
            [self.exceptionProxy holo_registFailedForTarget:target withProtocol:protocol];
        }
        return NO;
    }
    
    self.targetMap[protocolString] = target;
    return YES;
}

- (BOOL)registTarget:(Class)target withUrl:(NSString *)url {
    BOOL isSuccess = YES;
    
    url = [url holo_targetUrlPath];
    
    if (!target || !url) {
        HoloLog(@"[HoloTarget] Regist failed because the target (%@) or the url (%@) is nil.", target, url);
        isSuccess = NO;
    } else if (self.targetMap[url]) {
        HoloLog(@"[HoloTarget] Regist failed because the url (%@) was already registered.", url);
        isSuccess = NO;
    }
    
    if (!isSuccess) {
        if (self.exceptionProxy && [self.exceptionProxy respondsToSelector:@selector(holo_registFailedForTarget:withUrl:)]) {
            [self.exceptionProxy holo_registFailedForTarget:target withUrl:url];
        }
        return NO;
    }
    
    self.targetMap[url] = target;
    return YES;
}

- (nullable Class)matchTargetWithProtocol:(Protocol *)protocol {
    
    NSString *protocolString = NSStringFromProtocol(protocol);
    if (!protocolString) {
        HoloLog(@"[HoloTarget] Match failed because the protocol (%@) is nil.", protocolString);
        
        if (self.exceptionProxy && [self.exceptionProxy respondsToSelector:@selector(holo_matchFailedWithProtocol:)]) {
            [self.exceptionProxy holo_matchFailedWithProtocol:protocol];
        }
        return nil;
    }
    
    Class target = self.targetMap[protocolString];
    if (!target) {
        HoloLog(@"[HoloTarget] Match failed because the protocol (%@) was not registered.", protocolString);
        
        if (self.exceptionProxy && [self.exceptionProxy respondsToSelector:@selector(holo_matchFailedWithProtocol:)]) {
            [self.exceptionProxy holo_matchFailedWithProtocol:protocol];
        }
        return nil;
    }
    
    return target;
}

- (nullable Class)matchTargetWithUrl:(NSString *)url {
//    NSString *scheme = [url holo_targetUrlScheme];
//    if ([scheme.lowercaseString isEqualToString:@"http"] || [scheme.lowercaseString isEqualToString:@"https"]) {
//        return WKWebView.class;
//    }
    
    NSString *path = [url holo_targetUrlPath];
    if (!path) {
        HoloLog(@"[HoloTarget] Match failed because the url path (%@) is nil.", path);
        
        if (self.exceptionProxy && [self.exceptionProxy respondsToSelector:@selector(holo_matchFailedWithUrl:)]) {
            [self.exceptionProxy holo_matchFailedWithUrl:url];
        }
        return nil;
    }
    
    Class target = self.targetMap[path];
    if (!target) {
        HoloLog(@"[HoloTarget] Match failed because the url path (%@) was not registered.", path);
        
        if (self.exceptionProxy && [self.exceptionProxy respondsToSelector:@selector(holo_matchFailedWithUrl:)]) {
            [self.exceptionProxy holo_matchFailedWithUrl:path];
        }
        return nil;
    }
    
    return target;
}

- (nullable id)matchTargetInstanceWithProtocol:(Protocol *)protocol {
    Class cls = [self matchTargetWithProtocol:protocol];
    if (cls) {
        return [cls new];
    }
    return nil;
}

- (nullable id)matchTargetInstanceWithUrl:(NSString *)url {
    Class cls = [self matchTargetWithUrl:url];
    if (cls) {
        return [cls new];
    }
    return nil;
}

#pragma mark - getter
- (NSMutableDictionary<NSString *, Class> *)targetMap {
    if (!_targetMap) {
        _targetMap = [NSMutableDictionary new];
    }
    return _targetMap;
}

@end
