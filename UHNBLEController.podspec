#
# Be sure to run `pod lib lint UHNBLEController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "UHNBLEController"
  s.version          = "0.1.0"
  s.summary          = "A general BLE library that provides helpers for common task and the generic record access control point service."
  s.description      = <<-DESC
                       UHNBLEController provides a number of helpers, as listed below

                       * parsing BLE characteristics to standard types
                       * record access control point commands and parsing
                       * connecting with a BLE peripheral advertising specific services

                       DESC
  s.homepage         = "https://github.ehealthinnovation.org/JDRF/UHNBLEController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Nathaniel Hamming" => "nhamming@ehealthinnovation.org" }
  s.source           = { :git => "https://github.ehealthinnovation.org/JDRF/UHNBLEController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/NateHam80'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'UHNBLEController' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'CoreBluetooth'
  # s.dependency 'AFNetworking', '~> 2.3'
end
