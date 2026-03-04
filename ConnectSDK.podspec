Pod::Spec.new do |s|
  s.name         = "ConnectSDK"
  s.version      = "2.1.9"
  s.summary      = "Connect SDK"

  s.description  = "Connect SDK for multiple TV platforms including FireTV support."

  s.homepage     = "http://www.connectsdk.com/"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author       = { "Connect SDK" => "support@connectsdk.com" }

  s.platform     = :ios, "11.0"
  s.requires_arc = true

  s.source = {
    :git => "https://github.com/ConnectSDK/Connect-SDK-iOS.git",
    :tag => s.version,
    :submodules => true
  }

  s.libraries = "z", "icucore"
  s.xcconfig = { "OTHER_LDFLAGS" => "$(inherited) -ObjC" }

  non_arc_files =
    "core/Frameworks/asi-http-request/External/Reachability/*.{h,m}",
    "core/Frameworks/asi-http-request/Classes/*.{h,m}"

  # ================= Core =================
  s.subspec 'Core' do |sp|
    sp.source_files  = "ConnectSDKDefaultPlatforms.h", "core/**/*.{h,m}"
    sp.exclude_files = non_arc_files
    sp.private_header_files = "core/**/*_Private.h"

    sp.dependency 'ConnectSDK/no-arc'

    sp.ios.vendored_frameworks = [
      'core/Frameworks/LGCast/LGCast.xcframework',
      'core/Frameworks/LGCast/GStreamerForLGCast.xcframework'
    ]
  end

  # ================= no-arc =================
  s.subspec 'no-arc' do |sp|
    sp.source_files = non_arc_files
    sp.requires_arc = false
    sp.compiler_flags = '-w'
  end

  # ================= FireTV =================
  s.subspec 'FireTV' do |sp|
    firetv_dir = "modules/firetv"

    sp.dependency 'ConnectSDK/Core'

    # Source của FireTV
    sp.source_files = "#{firetv_dir}/**/*.{h,m}"

    # Static library của Amazon Fling
    sp.vendored_libraries = "#{firetv_dir}/libSimpleFlingLib-iphoneos.a"

    # Public headers
    sp.public_header_files = "#{firetv_dir}/Headers/AmazonFling/**/*.h"
    sp.header_mappings_dir = "#{firetv_dir}/Headers"

    sp.frameworks = "UIKit", "Foundation"
  end
end
