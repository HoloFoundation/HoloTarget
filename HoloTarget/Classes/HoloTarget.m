//
//  HoloTarget.m
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/25.
//

#import "HoloTarget.h"
#import <YAML-Framework/YAMLSerialization.h>

@interface HoloTarget ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *protocolsMap;

@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *urlsMap;

@property (nonatomic, strong) dispatch_semaphore_t lock;

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
    } else if (self.protocolsMap[protocolString]) {
        HoloLog(@"[HoloTarget] Regist failed because the protocol (%@) was already registered.", protocolString);
        isSuccess = NO;
    } else if (![target conformsToProtocol:protocol]) {
        HoloLog(@"[HoloTarget] Regist failed because the target (%@) is not conform to the protocol (%@).", target, protocolString);
        isSuccess = NO;
    }
    
    if (!isSuccess) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(holo_registFailedForTarget:withProtocol:)]) {
            [self.delegate holo_registFailedForTarget:target withProtocol:protocol];
        }
        return NO;
    }
    
    HOLO_LOCK(self.lock);
    self.protocolsMap[protocolString] = target;
    HOLO_UNLOCK(self.lock);
    return YES;
}

- (BOOL)registTarget:(Class)target withUrl:(NSString *)url {
    BOOL isSuccess = YES;
    
    NSString *path = [url holo_targetUrlPath];
    if (!target || !path) {
        HoloLog(@"[HoloTarget] Regist failed because the target (%@) or the url path (%@) is nil.", target, path);
        isSuccess = NO;
    } else if (self.urlsMap[path]) {
        HoloLog(@"[HoloTarget] Regist failed because the url path (%@) was already registered.", path);
        isSuccess = NO;
    }
    
    if (!isSuccess) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(holo_registFailedForTarget:withUrl:)]) {
            [self.delegate holo_registFailedForTarget:target withUrl:url];
        }
        return NO;
    }
    
    HOLO_LOCK(self.lock);
    self.urlsMap[path] = target;
    HOLO_UNLOCK(self.lock);
    return YES;
}

- (nullable Class)matchTargetWithProtocol:(Protocol *)protocol {
    NSString *protocolString = NSStringFromProtocol(protocol);
    if (!protocolString) {
        HoloLog(@"[HoloTarget] Match failed because the protocol (%@) is nil.", protocolString);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(holo_matchFailedWithProtocol:)]) {
            [self.delegate holo_matchFailedWithProtocol:protocol];
        }
        return nil;
    }
    
    Class target = self.protocolsMap[protocolString];
    if (!target) {
        HoloLog(@"[HoloTarget] Match failed because the protocol (%@) was not registered.", protocolString);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(holo_matchFailedWithProtocol:)]) {
            [self.delegate holo_matchFailedWithProtocol:protocol];
        }
        return nil;
    }
    
    return target;
}

- (nullable Class)matchTargetWithUrl:(NSString *)url {
    NSString *path = [url holo_targetUrlPath];
    if (!path) {
        HoloLog(@"[HoloTarget] Match failed because the url path (%@) is nil.", path);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(holo_matchFailedWithUrl:)]) {
            [self.delegate holo_matchFailedWithUrl:url];
        }
        return nil;
    }
    
    Class target = self.urlsMap[path];
    if (!target) {
        HoloLog(@"[HoloTarget] Match failed because the url path (%@) was not registered.", path);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(holo_matchFailedWithUrl:)]) {
            [self.delegate holo_matchFailedWithUrl:url];
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
- (NSMutableDictionary<NSString *, Class> *)protocolsMap {
    if (!_protocolsMap) {
        _protocolsMap = [NSMutableDictionary new];
    }
    return _protocolsMap;
}

- (NSMutableDictionary<NSString *, Class> *)urlsMap {
    if (!_urlsMap) {
        _urlsMap = [NSMutableDictionary new];
    }
    return _urlsMap;
}

- (dispatch_semaphore_t)lock {
    if (!_lock) {
        _lock = dispatch_semaphore_create(1);
    }
    return _lock;
}

@end
