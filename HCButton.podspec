Pod::Spec.new do |s|
  version = "0.0.1"
  s.name         = "HCButton"
  s.version      = version
  s.summary      = "Functional button implementation."
  s.homepage     = "https://github.com/hcrub/HCButton"
  s.author       = { "Neil Burchfield" => "neil.burchfield@gmail.com" }
  s.source       = { :git => "git", :tag => version }
  s.platform     = :ios, '8.0'
  s.source_files = 'HCButton/*.{h,m}'
  s.requires_arc = true
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.resource_bundle = { 'HCButton' => 'HCButton.bundle/**/*.*' }

  s.dependency  'ReactiveCocoa', '2.5'
end