require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = package["name"]
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-qq
                   DESC
  s.homepage     = "https://github.com/haxibiao/react-native-qq"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "PBK-B" => "bin@PBK6.cn" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/haxibiao/react-native-qq.git", :tag => "#{s.version}" }
  
  # s.resource = "ios/TYRZResource.bundle"

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true
  
  s.vendored_frameworks = [
    'ios/**/*.framework'
  ]

  s.dependency "React"
  # ...
  # s.dependency "..."
end

