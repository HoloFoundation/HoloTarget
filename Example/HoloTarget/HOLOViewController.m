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
    
    NSString *url = @"http://abc/def?a=1&b=2";
    
    [[HoloTarget sharedInstance] registTarget:UIViewController.class withUrl:url];
    
    UIViewController *vc = [HoloNavigator matchViewControllerWithUrl:url];
    
    NSDictionary *params = [HoloNavigator matchUrlParamsWithViewController:vc];
    
    NSLog(@"----%@", params);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIViewController *vc = [HoloNavigator matchViewControllerWithProtocol:@protocol(HoloDemoViewControllerAProtocol)];
    [(UIViewController<HoloDemoViewControllerAProtocol> *)vc holoDemoViewControllerA:@"VC A"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
