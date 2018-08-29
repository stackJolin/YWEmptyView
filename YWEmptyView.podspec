#
# Be sure to run `pod lib lint YWEmptyView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YWEmptyView'
  s.version          = '0.1.1'
  s.summary          = 'A short description of YWEmptyView.'

  s.homepage         = 'https://github.com/stackJolin/YWEmptyView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '601584870@qq.com' => '601584870@qq.com' }
  s.source           = { :git => 'https://github.com/stackJolin/YWEmptyView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  
  s.source_files = 'YWEmptyView/Classes/**/*'
  s.prefix_header_file = 'YWEmptyView/Classes/YWEmptyView.h'
  #s.public_header_files = 'YWEmptyView/Classes/**/*.h'
  s.resources    = 'YWEmptyView/YWEmptyView.bundle'
  
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'Masonry'
  s.dependency 'YWCoreKit'
end
