#
# Be sure to run `pod lib lint IOStickyHeader.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "IOStickyHeader"
  s.version          = "1.0.4"
  s.summary          = "Parallax and Sticky header done right using UICollectionViewLayout"
  s.description      = <<-DESC
                       UICollectionView are flexible and you can use supplementary views to
                       anything you wanted.
                       DESC
  s.homepage         = "https://github.com/BenjaminPrieur/IOStickyHeader.git"
  s.license          = 'MIT'
  s.author           = { "Benjamin Prieur" => "benjamin@prieur.org" }
  s.source           = { :git => "https://github.com/BenjaminPrieur/IOStickyHeader.git", :tag => s.version.to_s }

  s.swift_version           = '4.2'

  s.ios.deployment_target   = '9.0'
  s.requires_arc = true

  s.source_files = 'Sources/**/*.{swift}'
end
