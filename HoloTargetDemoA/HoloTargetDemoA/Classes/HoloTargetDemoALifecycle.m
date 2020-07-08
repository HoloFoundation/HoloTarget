//
//  HoloTargetDemoALifecycle.m
//  HoloTargetDemoA
//
//  Created by 与佳期 on 2020/6/25.
//

#import "HoloTargetDemoALifecycle.h"
#import <HoloTargetProtocolPool/HoloTargetProtocolPool.h>
#import <HoloTarget/HoloTarget.h>
#import "HoloDemoViewControllerA.h"

@implementation HoloTargetDemoALifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    [[HoloTarget sharedInstance] registTarget:HoloDemoViewControllerA.class withProtocol:@protocol(HoloDemoViewControllerAProtocol)];
    return YES;
}

@end
