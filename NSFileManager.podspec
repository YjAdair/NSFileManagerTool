Pod::Spec.new do |s|
s.name         = "NSFileManager"
s.version      = "0.0.1"
s.summary      = "YJFileManager is a hanle file tool."

s.homepage     = "https://github.com/YjAdair/NSFileManagerTool"
s.license      = "MIT"
s.author             = { "YjAdair" => "544421581@qq.com" }

s.platform     = :ios, "7.0"

#  When using multiple platforms
# s.ios.deployment_target = "5.0"
# s.osx.deployment_target = "10.7"
# s.watchos.deployment_target = "2.0"
# s.tvos.deployment_target = "9.0"

s.source       = { :git => "https://github.com/YjAdair/NSFileManagerTool.git", :tag => "#{s.version}" }

s.source_files  = "NSFileManager/*.{h,m}"

s.frameworks = "Foundation"
s.requires_arc = true
end
