//
//  NSString+HoloTargetUrlParser.m
//  HoloTarget
//
//  Created by 与佳期 on 2020/7/5.
//

#import "NSString+HoloTargetUrlParser.h"

static NSString     *kHoloTargetUrl          = nil;
static NSString     *kHoloTargetUrlScheme    = nil;
static NSString     *kHoloTargetUrlPath      = nil;
static NSDictionary *kHoloTargetUrlParams    = nil;

@implementation NSString (HoloTargetUrlParser)

- (NSString *)holo_targetUrlScheme {
    if (![self isEqualToString:kHoloTargetUrl]) {
        [self _holo_parseTargetUrl];
    }
    return kHoloTargetUrlScheme;
}

- (NSString *)holo_targetUrlPath {
    if (![self isEqualToString:kHoloTargetUrl]) {
        [self _holo_parseTargetUrl];
    }
    return kHoloTargetUrlPath;
}

- (NSDictionary *)holo_targetUrlParams {
    if (![self isEqualToString:kHoloTargetUrl]) {
        [self _holo_parseTargetUrl];
    }
    return kHoloTargetUrlParams;
}


- (void)_holo_parseTargetUrl {
    if (self.length <= 0) return;
    
    kHoloTargetUrl = self;
    kHoloTargetUrlScheme = nil;
    kHoloTargetUrlPath = nil;
    kHoloTargetUrlParams = nil;
    
    NSString *target = nil;
    if ([self containsString:@"://"]) {
        NSArray<NSString *> *array = [self componentsSeparatedByString:@"://"];
        if (array.count >= 2 && array[0].length > 0) kHoloTargetUrlScheme = array[0];
        if (array.count >= 2 && array[1].length > 0) target = array[1];
    } else {
        target = self;
    }
    
    if (target.length <= 0) return;
    target = [target _holo_filterPrefixSuffix];
    
    NSString *paramString = nil;
    if ([self containsString:@"?"]) {
        NSArray<NSString *> *array = [target componentsSeparatedByString:@"?"];
        if (array.count >= 2 && array[0].length > 0) kHoloTargetUrlPath = array[0];
        if (array.count >= 2 && array[1].length > 0) paramString = array[1];
    } else {
        kHoloTargetUrlPath = target;
    }
    if (kHoloTargetUrlPath) {
        kHoloTargetUrlPath = [kHoloTargetUrlPath _holo_filterPrefixSuffix];
    }
    
    if (paramString.length <= 0) return;
    paramString = [paramString _holo_filterPrefixSuffix];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary new];
    NSArray *paramArray = [paramString componentsSeparatedByString:@"&"];
    [paramArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<NSString *> *array = [obj componentsSeparatedByString:@"="];
        if (array.count >= 2 && array[0].length > 0 && array[1].length > 0) paramDict[array[0]] = array[1];
    }];
    
    if (paramDict.count > 0) kHoloTargetUrlParams = paramDict.copy;
}

- (NSString *)_holo_filterPrefixSuffix {
    NSString *target = self;
    while ([target hasPrefix:@"/"]) {
        target = [target substringFromIndex:1];
    }
    while ([target hasSuffix:@"/"]) {
        target = [target substringToIndex:target.length-1];
    }
    return target;
}

@end
