//
//  HoloDemoViewControllerA.m
//  HoloTargetDemoA
//
//  Created by 与佳期 on 2020/6/17.
//

#import "HoloDemoViewControllerA.h"
#import <HoloTarget/HoloNavigator.h>
#import <HoloTargetProtocolPool/HoloTargetProtocolPool.h>

@interface HoloDemoViewControllerA ()

@end

@implementation HoloDemoViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIViewController *vc = [[HoloNavigator sharedInstance] matchViewControllerWithProtocol:@protocol(HoloDemoViewControllerBProtocol)];
    [(UIViewController<HoloDemoViewControllerBProtocol> *)vc holoDemoViewControllerB:@"VC B"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - HoloDemoViewControllerAProtocol
- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)holoDemoViewControllerA:(NSString *)title {
    self.title = title;
    NSLog(@"------- performSelector:holoDemoViewControllerA");
}

@end
