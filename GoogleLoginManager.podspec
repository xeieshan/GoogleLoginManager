Pod::Spec.new do |s|
  s.name             = 'GoogleLoginManager'
  s.version          = '0.1.1'
  s.summary          = 'Google Login Manager for iOS'
 
  s.description      = <<-DESC
Login with google easily. Login Manager for Google (Google Plus Deprecated). Written in Swift 3.0 and Objective C.
                       DESC
 
  s.homepage         = 'https://github.com/xeieshan/GoogleLoginManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Zeeshan Haider' => 'xeieshan@gmail.com' }
  s.source           = { :git => 'https://github.com/xeieshan/GoogleLoginManager.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'GoogleLoginManager/GoogleLoginManager.{h,m}'
 
end