#
# Be sure to run `pod lib lint HoloTarget.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HoloTarget'
  s.version          = '0.2.0'
  s.summary          = '组件化页面跳转及路由方案.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
通过注册 protocol 与 viewcontroller 的键值对，根据 protocol 获取 VC 并调用协议方法然后 push；通过注册 url 与 viewcontroller 的键值对，根据 url 获取 VC 然后 push（将 url 中的参数取出作为 NSDicitionary 绑定给 VC）.
                       DESC

  s.homepage         = 'https://github.com/HoloFoundation/HoloTarget'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gonghonglou' => 'gonghonglou@icloud.com' }
  s.source           = { :git => 'https://github.com/HoloFoundation/HoloTarget.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HoloTarget/Classes/**/*'
  
   s.resource_bundles = {
     'HoloTarget' => ['HoloTarget/Assets/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'YAML-Framework'
  
end
