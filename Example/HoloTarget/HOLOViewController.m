//
//  HOLOViewController.m
//  HoloTarget
//
//  Created by gonghonglou on 06/15/2020.
//  Copyright (c) 2020 gonghonglou. All rights reserved.
//

#import "HOLOViewController.h"
#import <HoloTarget/HoloNavigator.h>
#import <HoloTarget/HoloTarget.h>
#import <HoloTargetProtocolPool/HoloTargetProtocolPool.h>

@interface HOLOViewController ()

@end

@implementation HOLOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"HOLO";
    
    [[HoloTarget sharedInstance] registTargetsFromYAML];

    
    NSString *url = @"http://holo/demoA/vcA?a=1&b=2";
    
    [[HoloTarget sharedInstance] registTarget:UIViewController.class withUrl:url];
    
    UIViewController *vc = [HoloNavigator matchViewControllerWithUrl:url];
    
    NSDictionary *params = [HoloNavigator matchUrlParamsWithViewController:vc];
    
    NSLog(@"----vc:%@---params:%@", vc,  params);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIViewController *vc = [HoloNavigator matchViewControllerWithProtocol:@protocol(HoloDemoViewControllerAProtocol)];
    [(UIViewController<HoloDemoViewControllerAProtocol> *)vc holoDemoViewControllerA:@"VC A"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
