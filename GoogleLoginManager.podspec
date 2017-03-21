Pod::Spec.new do |s|
  s.name             = 'GoogleLoginManager'
  s.version          = '0.1.0'
  s.summary          = 'By far the most fantastic view I have seen in my entire life. No joke.'
 
  s.description      = <<-DESC
This fantastic view changes its color gradually makes your app look fantastic!
                       DESC
 
  s.homepage         = 'https://github.com/xeieshan/GoogleLoginManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Zeeshan Haider' => 'xeieshan@gmail.com' }
  s.source           = { :git => 'https://github.com/xeieshan/GoogleLoginManager.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'GoogleLoginManager/GoogleLoginManager.{h,m}'
 
end