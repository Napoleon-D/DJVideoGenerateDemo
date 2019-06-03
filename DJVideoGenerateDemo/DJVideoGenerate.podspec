

Pod::Spec.new do |s|

s.name        = "DJVideoGenerate"

s.version     = "1.1.0"

s.platform = :ios, "9.0"

s.summary     = "~~iOS~~图片生成视频~~图片、音频，生成音视频"

s.homepage    = "https://github.com/ox-man"

s.author     = { "ox-man" => "wangtao199205@qq.com" }

s.source      = { :git => "https://github.com/ox-man/DJVideoGenerateDemo.git",:tag => s.version.to_s}

s.source_files = "DJVideoGenerateDemo/DJVideoGenerateDemo/DJVideoGenerate/*.{h,m}"

s.license     = { :type => "MIT", :file => "LICENSE" }

s.requires_arc = true

s.dependency "SDWebImage", "~> 5.0.0-beta3"

end
