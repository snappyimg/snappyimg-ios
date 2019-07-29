

Pod::Spec.new do |s|
  s.name             = 'SnappyImg'
  s.version          = '0.4.0'
  s.summary          = 'Scale, crop and optimize images on-the-fly, with all the benefits of a CDN.'

  s.description      = <<-DESC
Scale, crop and optimize images on-the-fly, with all the benefits of a CDN. This library helps you to create correct urls to get images from http://snappyimg.com as specified.
                       DESC

  s.homepage         = 'https://github.com/snappyimg/snappyimg-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Martin vytick Vytrhlik' => 'dev@mangoweb.cz' }
  s.source           = { :git => 'https://github.com/snappyimg/snappyimg-ios.git', :tag => s.version.to_s }
#  s.social_media_url = 'https://twitter.com/vytick'
  s.ios.deployment_target = '10.3.1'
  s.swift_version = '4.2'

  s.source_files = 'SnappyImg/Classes/**/*'
  s.dependency 'CryptoSwift'
end
