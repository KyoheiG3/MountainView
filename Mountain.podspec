Pod::Spec.new do |s|
  s.name         = "Mountain"
  s.summary      = "The animation curve looks like Mountain View."
  s.homepage     = "https://github.com/KyoheiG3/MountainView"
  s.version      = "0.1.0"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Kyohei Ito" => "je.suis.kyohei@gmail.com" }
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.source       = { :git => "https://github.com/KyoheiG3/MountainView.git", :tag => s.version.to_s }
  s.source_files = "Mountain/**/*.{h,swift}"
  s.requires_arc = true
  s.frameworks   = "UIKit"
end
