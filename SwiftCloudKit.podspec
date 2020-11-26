
Pod::Spec.new do |s|

  s.name         = "SwiftCloudKit"
  s.version      = "0.8.0"
  s.summary      = "A short description of SwiftCloudKit."

  s.homepage         = 'https://github.com/jackiehu/SwiftCloudKit'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jackiehu' => 'jackie' }
  s.source           = { :git => 'https://github.com/jackiehu/SwiftCloudKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  
  s.swift_versions     = ['5.0','5.1','5.2']
  s.requires_arc = true
  s.source_files = 'Sources/**/*'

end
