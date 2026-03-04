Pod::Spec.new do |s|
  s.name         = "ConnectSDK"
  s.version      = "2.1.9"
  s.summary      = "Connect SDK is an open source framework that connects your mobile apps with multiple TV platforms."

  s.description  = <<-DESC
Connect SDK is an open source framework that connects your mobile apps with multiple TV platforms.
DESC

  s.homepage     = "http://www.connectsdk.com/"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author       = { "Connect SDK" => "support@connectsdk.com" }

  s.platform     = :ios, "11.0"
  s.ios.deployment_target = "11.0"

  s.source       = {
    :git => "https://github.com/ConnectSDK/Connect-SDK-iOS.git",
    :tag => s.version,
    :submodules => true
  }

  s.requires_arc = true
  s.libraries    = "z", "icucore"

  s.xcconfig = {
    "OTHER_LDFLAGS" => "$(inherited) -ObjC"
  }

  s.prefix_header_contents = <<-PREFIX
#define CONNECT_SDK_VERSION @"#{s.version}"
#ifndef kConnectSDKWirelessSSIDChanged
#define kConnectSDKWirelessSSIDChanged @"Connect_SDK_Wireless_SSID_Changed"
#endif
PREFIX

  non_arc_files =
    "core/Frameworks/asi-http-request/External/Reachability/*.{h,m}",
    "core/Frameworks/asi-http-request/Classes/*.{h,m}"

  # ================= CORE =================
  s.subspec 'Core' do |sp|
    sp.source_files  = "ConnectSDKDefaultPlatforms.h", "core/**/*.{h,m}"
    sp.exclude_files = non_arc_files +
                       ["core/ConnectSDK*Tests/**/*",
                        "core/Frameworks/LGCast/**/*.h"]

    sp.private_header_files = "core/**/*_Private.h"
    sp.requires_arc = true
    sp.dependency 'ConnectSDK/no-arc'

    sp.ios.vendored_frameworks =
      'core/Frameworks/LGCast/LGCast.xcframework',
      'core/Frameworks/LGCast/GStreamerForLGCast.xcframework'

    sp.preserve_paths =
      'core/Frameworks/LGCast/LGCast.xcframework',
      'core/Frameworks/LGCast/GStreamerForLGCast.xcframework'
  end

  # ================= NO ARC =================
  s.subspec 'no-arc' do |sp|
    sp.source_files = non_arc_files
    sp.requires_arc = false
    sp.compiler_flags = '-w'
  end

  # ================= GOOGLE CAST =================
  s.subspec 'GoogleCast' do |sp|
    cast_dir = "modules/google-cast"

    sp.dependency 'ConnectSDK/Core'
    sp.source_files = "#{cast_dir}/**/*.{h,m}"
    sp.exclude_files = "#{cast_dir}/*Tests/**/*"
    sp.private_header_files = "#{cast_dir}/**/*_Private.h"

    cast_version = "2.7.1"
    sp.dependency "google-cast-sdk", cast_version
    sp.framework = "GoogleCast"

    sp.xcconfig = {
      "FRAMEWORK_SEARCH_PATHS" =>
      "$(PODS_ROOT)/google-cast-sdk/GoogleCastSDK-#{cast_version}-Release"
    }
  end

  # ================= FIRE TV =================
  s.subspec 'FireTV' do |sp|
    firetv_dir = "modules/firetv"

    sp.dependency 'ConnectSDK/Core'

    sp.source_files = "#{firetv_dir}/**/*.{h,m}"
    sp.exclude_files = "#{firetv_dir}/*Tests/**/*"
    sp.private_header_files = "#{firetv_dir}/**/*_Private.h"

    # Amazon Fling must be added manually to the app target
    sp.frameworks = "UIKit", "Foundation"
    sp.libraries  = "z", "c++"

    sp.pod_target_xcconfig = {
      "OTHER_LDFLAGS" => "$(inherited) -ObjC"
    }
  end

end
