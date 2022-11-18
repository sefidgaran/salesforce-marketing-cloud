#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sfmc_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sfmc_plugin'
  s.version          = '3.3.1'
  s.summary          = 'SFMC Flutter plugin project.'
  s.description      = <<-DESC
  MarketingCloudSDK - MobilePush SDK for Flutter.
                       DESC
  s.homepage         = 'https://www.linkedin.com/in/farshid-sefidgaran-51567614/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Farshid Sefidgaran' => 'sefidgaran@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'MarketingCloudSDK', '= 8.0.8'
  s.dependency 'MarketingCloud-SFMCSdk', '= 1.0.6'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
