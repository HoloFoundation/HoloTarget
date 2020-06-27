//
//  HoloDemoViewControllerB.m
//  HoloTargetDemoB
//
//  Created by 与佳期 on 2020/6/17.
//

#import "HoloDemoViewControllerB.h"

@interface HoloDemoViewControllerB ()

@end

@implementation HoloDemoViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - HoloDemoViewControllerBProtocol
- (void)holoDemoViewControllerB:(NSString *)title {
    self.title = title;
    NSLog(@"------- performSelector:holoDemoViewControllerB");
}

@end
