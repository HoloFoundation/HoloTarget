//
//  HoloTargetDemoBLifecycle.m
//  HoloTargetDemoB
//
//  Created by 与佳期 on 2020/6/25.
//

#import "HoloTargetDemoBLifecycle.h"
#import <HoloTarget/HoloTarget.h>
#import <HoloTargetProtocolPool/HoloTargetProtocolPool.h>
#import "HoloDemoViewControllerB.h"
#import "HoloTargetDemoAMainTarget.h"

@implementation HoloTargetDemoBLifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    [[HoloTarget sharedInstance] registTarget:HoloDemoViewControllerB.class withProtocol:@protocol(HoloDemoViewControllerBProtocol)];
    
    [[HoloTarget sharedInstance] registTarget:HoloTargetDemoAMainTarget.class withProtocol:@protocol(HoloTargetDemoAProtocol)];
    return YES;
}

@end
