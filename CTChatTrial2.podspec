#
# Be sure to run `pod lib lint CTChatTrial2.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CTChatTrial2'
  s.version          = '0.1.0'
  s.summary          = 'This is Chat Test lib'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is Chat Test lib....
                       DESC

  s.homepage         = 'https://github.com/jasminceco/CTChatTrial'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jasmin Ceco' => 'jasminceco@gmail.com' }
  s.source           = { :git => 'https://github.com/jasminceco/CTChatTrial.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.3'

  s.source_files = 'CTChatTrial2/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CTChatTrial2' => ['CTChatTrial2/Assets/*.png']
  # }

# s.public_header_files = 'Pod/Classes/**/*.h'

 s.frameworks = 'UIKit'

 s.static_framework = true
 s.dependency 'Firebase/Auth'
 s.dependency 'Firebase/Database'
 s.dependency 'Firebase/Storage'
 s.dependency 'ObjectMapper'
 s.dependency 'Firebase'
 s.dependency 'IQKeyboardManagerSwift'

end
