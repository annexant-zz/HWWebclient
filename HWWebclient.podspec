Pod::Spec.new do |spec|

  spec.name         = "HWWebclient"
  spec.version      = "1.0.0"
  spec.platform     = :ios, "10.0"
  spec.summary      = "REST client"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Andrey Ostroverkhiy" => "a.ostroverkhiy@mobidev.biz" }
  spec.swift_version = "5.0"

  spec.source_files  = "HWWebclient/Sources"
#, "Sources/**/*.{h,m,swift}"
  spec.requires_arc = true

  spec.dependency "Alamofire", "~> 4.8.1"
  spec.dependency "SwiftyJSON", "~> 4.2.0"

 spec.description  = <<-DESC
Reliable and convenient REST client, decidet for maximum economy with services descrription
						DESC

spec.homepage     = "https://github.com/annexant-zz/HWWebclient"
spec.source       = { :git => "https://github.com/annexant-zz/HWWebclient.git", :tag => "#{spec.version}" }
end
