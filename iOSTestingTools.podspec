Pod::Spec.new do |s|
  s.name             = 'iOSTestingTools'
  s.version          = '1.0.0'
  s.summary          = 'Testing utilities and mocking framework for iOS applications.'
  s.description      = <<-DESC
    iOSTestingTools provides comprehensive testing utilities and mocking framework
    for iOS. Features include mock generators, stub helpers, XCTest extensions,
    async testing utilities, snapshot testing, and performance test helpers.
  DESC

  s.homepage         = 'https://github.com/muhittincamdali/iOSTestingTools'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/iOSTestingTools.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.osx.deployment_target = '12.0'

  s.swift_versions = ['5.9', '5.10', '6.0']
  s.source_files = 'Sources/**/*.swift'
  s.frameworks = 'Foundation', 'XCTest'
end
