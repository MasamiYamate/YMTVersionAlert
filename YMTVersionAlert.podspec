#
#  Be sure to run `pod spec lint YMTVersionAlert.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
Pod::Spec.new do |s|
s.name         = "YMTVersionAlert"
s.version      = "1.0.1"
s.summary      = "Urge the latest version to update for iOS."
s.license      = { :type => "MIT", :file => "LICENSE" }
s.homepage     = "https://github.com/MasamiYamate/YMTVersionAlert.git"
s.author       = { "MasamiYamate" => "yamate.inquiry@mail.yamatte.net" }
s.source       = { :git => "https://github.com/MasamiYamate/YMTVersionAlert.git", :tag => "#{s.version}" }
s.platform     = :ios, "8.0"
s.requires_arc = true
s.source_files = 'YMTVersionAlert/**/*.{swift}'
end

