# HoloTarget

[![CI Status](https://img.shields.io/travis/HoloFoundation/HoloTarget.svg?style=flat)](https://travis-ci.org/HoloFoundation/HoloTarget)
[![Version](https://img.shields.io/cocoapods/v/HoloTarget.svg?style=flat)](https://cocoapods.org/pods/HoloTarget)
[![License](https://img.shields.io/cocoapods/l/HoloTarget.svg?style=flat)](https://cocoapods.org/pods/HoloTarget)
[![Platform](https://img.shields.io/cocoapods/p/HoloTarget.svg?style=flat)](https://cocoapods.org/pods/HoloTarget)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

详细介绍参见博客地址：[组件化页面跳转及路由方案](http://gonghonglou.com/2020/07/07/pod-target/)


```objc
// 1、protocol 方式支持页面跳转
// 提供方提前注册 protocol
[[HoloTarget sharedInstance] registTarget:ViewController.class withProtocol:@protocol(ViewControllerProtocol)];

// 调用方根据 protocol 获取 vc 跳转
UIViewController *vc = [HoloNavigator matchViewControllerWithProtocol:@protocol(ViewControllerProtocol)];
[(UIViewController<ViewControllerProtocol> *)vc viewController:@"title"];
[self.navigationController pushViewController:vc animated:YES];
    
    
// 2、url 方式支持页面路由
// 提供方提前注册 url
[[HoloTarget sharedInstance] registTarget:ViewController.class withUrl:@"holo://demo/vc?a=1&b=2"];

// 调用方根据 url 获取 vc 跳转
UIViewController *vc = [HoloNavigator matchViewControllerWithUrl:@"holo://demo/vc?a=1&b=2"];
[self.navigationController pushViewController:vc animated:YES];
// vc 内部获取入参
NSDictionary *params = [HoloNavigator matchUrlParamsWithViewController:vc];
NSLog(@"vc params:%@", params);
```


## Installation

HoloTarget is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HoloTarget'
```

## Author

gonghonglou, gonghonglou@icloud.com

## License

HoloTarget is available under the MIT license. See the LICENSE file for more info.


