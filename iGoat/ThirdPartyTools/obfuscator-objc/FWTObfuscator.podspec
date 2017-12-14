Pod::Spec.new do |s|
  s.name         = "FWTObfuscator"
  s.platform     = :ios
  s.ios.deployment_target = "7.0"
  s.version      = "0.2.3"
  s.summary      = "ObjC library that supports objc-obfuscator gem"
  s.description  = <<-DESC
                   A simple obfuscator that encrypts strings in source files.
                   DESC
  s.homepage     = "http://github.com/FutureWorkshops/Obfuscator-ruby"
  s.license      = 'BSD'
  s.author       = { "fabio@futureworkshops.com" => "Fabio Gallonetto" }
  s.source       = { :git => "https://github.com/FutureWorkshops/FWTObfuscator.git", :tag => s.version.to_s }

  s.requires_arc = true

  s.source_files = "obfuscator-objc/*.{h,m}"
  s.frameworks = 'Security'
  s.public_header_files = 'obfuscator-objc/*.h'
  s.private_header_files = 'obfuscator-objc/FWTObfuscator+Private.h'
  
end
