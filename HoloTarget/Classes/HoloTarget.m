//
//  HoloTarget.m
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/25.
//

#import "HoloTarget.h"
#import <YAML-Framework/YAMLSerialization.h>
#import "HoloTargetMacro.h"
#import "NSString+HoloTargetUrlParser.h"

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

- (void)registTargetsFromYAML {
    NSString *path = [[NSBundle mainBundle] pathForResource:@".HOLO_ALL_TARGETS" ofType:@"yaml"];
    NSInputStream *stream = [[NSInputStream alloc] initWithFileAtPath:path];
    NSDictionary *yaml = [YAMLSerialization objectWithYAMLStream:stream
                                                         options:kYAMLReadOptionStringScalars
                                                           error:nil];
    
    [yaml enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull cls, NSDictionary * _Nonnull dict, BOOL * _Nonnull stop) {
        
        NSArray<NSString *> *urls = dict[@"urls"];
        [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
            [[HoloTarget sharedInstance] registTarget:NSClassFromString(cls) withUrl:url];
        }];
        
        NSArray<NSString *> *protocols = dict[@"protocols"];
        [protocols enumerateObjectsUsingBlock:^(NSString * _Nonnull protocol, NSUInteger idx, BOOL * _Nonnull stop) {
            [[HoloTarget sharedInstance] registTarget:NSClassFromString(cls) withProtocol:NSProtocolFromString(protocol)];
        }];
        
    }];
}

- (BOOL)registTarget:(Class)target withProtocol:(Protocol *)protocol {
    if (self.targetMap[NSStringFromProtocol(protocol)]) {
        if (self.exceptionProxy && [self.exceptionProxy respondsToSelector:@selector(holo_registFailedBecauseAlreadyRegistTheProtocol:forTarget:)]) {
            [self.exceptionProxy holo_registFailedBecauseAlreadyRegistTheProtocol:protocol forTarget:target];
        } else {
            HoloLog(@"regist failed because the protocol (%@) was already registered", NSStringFromProtocol(protocol));
        }
        return NO;
    } else if (![target conformsToProtocol:protocol]) {
        if (self.exceptionProxy && [self.exceptionProxy respondsToSelector:@selector(holo_registFailedBecauseConnotConformTheProtocol:forTarget:)]) {
            [self.exceptionProxy holo_registFailedBecauseConnotConformTheProtocol:protocol forTarget:target];
        } else {
            HoloLog(@"regist failed because the target (%@) is not conform to the protocol (%@)", NSStringFromClass(target), NSStringFromProtocol(protocol));
        }
        return NO;
    }
    
    self.targetMap[NSStringFromProtocol(protocol)] = target;
    return YES;
}

- (BOOL)registTarget:(Class)target withUrl:(NSString *)url {
    url = [url holo_targetUrlPath];
    
    if (self.targetMap[url]) {
        if (self.exceptionProxy && [self.exceptionProxy respondsToSelector:@selector(holo_registFailedBecauseAlreadyRegistTheUrl:forTarget:)]) {
            [self.exceptionProxy holo_registFailedBecauseAlreadyRegistTheUrl:url forTarget:target];
        } else {
            HoloLog(@"regist failed because the url (%@) was already registered", url);
        }
        return NO;
    }
    
    self.targetMap[url] = target;
    return YES;
}

- (nullable Class)matchTargetWithProtocol:(Protocol *)protocol {
    Class target = self.targetMap[NSStringFromProtocol(protocol)];
    if (target) {
        return target;
    }
    
    if (self.exceptionProxy && [self.exceptionProxy respondsToSelector:@selector(holo_matchFailedBecauseNotRegistTheProtocol:)]) {
        [self.exceptionProxy holo_matchFailedBecauseNotRegistTheProtocol:protocol];
    } else {
        HoloLog(@"match failed because the protocol (%@) was not registered", NSStringFromProtocol(protocol));
    }
    return nil;
}

- (nullable Class)matchTargetWithUrl:(NSString *)url {
    url = [url holo_targetUrlPath];
    
    Class target = self.targetMap[url];
    if (target) {
        return target;
    }
    
    if (self.exceptionProxy && [self.exceptionProxy respondsToSelector:@selector(holo_matchFailedBecauseNotRegistTheUrl:)]) {
        [self.exceptionProxy holo_matchFailedBecauseNotRegistTheUrl:url];
    } else {
        HoloLog(@"match failed because the url (%@) was not registered", url);
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
