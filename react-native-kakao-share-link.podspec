require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
kakao_sdk_version = "2.11.1"

Pod::Spec.new do |s|
  s.name         = "react-native-kakao-share-link"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/millo-L/react-native-kakao-share-link.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,cc,cpp,m,mm,swift}"
  s.requires_arc = true

  s.dependency "React-Core"

  if defined?($KakaoSDKVersion)
    Pod::UI.puts "#{s.name}: Using user specified Kakao SDK version '#{$KakaoSDKVersion}'"
    kakao_sdk_version = $KakaoSDKVersion
  end

  s.dependency "KakaoSDKCommon", kakao_sdk_version
  s.dependency "KakaoSDKShare", kakao_sdk_version
  s.dependency "KakaoSDKTemplate", kakao_sdk_version
end
