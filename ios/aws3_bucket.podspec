#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint aws3_bucket.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'aws3_bucket'
  s.version          = '0.0.1'
  s.summary          = 'This plugin allows users to  upload and delete files on amazon s3 storage'
  s.description      = <<-DESC
This plugin allows users to list, upload and delete image for amazon s3 cognito
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AWSS3'
  s.dependency 'AWSCore'
  s.dependency 'AWSCognito'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
