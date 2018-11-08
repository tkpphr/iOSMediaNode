Pod::Spec.new do |s|
  s.name         = "iOSMediaNode"
  s.version      = "1.0.0"
  s.summary      = "The tree node that has image and sound."
  s.homepage     = "https://github.com/tkpphr"
  s.license      = "MIT"
  s.author       = "tkpphr"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/tkpphr/iOSMediaNode.git", :tag => "#{s.version}" }
  s.source_files  = "iOSMediaNode/**/*.swift"
  s.resource_bundles = {
    'iOSMediaNode' => [
    'iOSMediaNode/**/*.{xib,strings}']
  }
  s.requires_arc = true
end
