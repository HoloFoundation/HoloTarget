//
//  HoloTargetDemoAMainTarget.m
//  HoloTargetDemoA
//
//  Created by 与佳期 on 2020/7/5.
//

#import "HoloTargetDemoAMainTarget.h"
#import "HoloDemoViewControllerA.h"
#import "HoloDemoViewControllerA2.h"

@implementation HoloTargetDemoAMainTarget

- (UIViewController *)viewControllerAWithTitle:(NSString *)title {
    HoloDemoViewControllerA *vc = [HoloDemoViewControllerA new];
    vc.title = title;
    return vc;
}

- (UIViewController *)viewControllerA2WithTitle:(NSString *)title {
    HoloDemoViewControllerA2 *vc = [HoloDemoViewControllerA2 new];
    vc.title = title;
    return vc;
}

@end
