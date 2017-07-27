#
# Be sure to run `pod lib lint Walle.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Walle'
  s.version          = '1.2.0'
  s.summary          = 'iOS Application performance monitoring'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
iOS Application performance monitoring.
                       DESC

  s.homepage         = 'https://github.com/hongruqi/Walle'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'quvideo' => 'hongru.qi@quvideo.com' }
  s.source           = { :git => 'https://github.com/hongruqi/Walle.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Walle/Classes/**/*'
  s.dependency 'CocoaLumberjack'
  s.dependency 'JRSwizzle'
end
