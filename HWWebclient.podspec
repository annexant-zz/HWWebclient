Pod::Spec.new do |spec|

  spec.name         = "HWWebclient"
  spec.version      = "1.0.0"
  spec.platform     = :ios, "10.0"
  spec.summary      = "REST client"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Andrey Ostroverkhiy" => "a.ostroverkhiy@mobidev.biz" }
  spec.swift_version = "5.0"

  spec.source_files  = "Sources", "Classes/**/*.{h,m,swift}"
  spec.requires_arc = true

  spec.dependency "Alamofire", "~> 4.8.1"
  spec.dependency "SwiftyJSON", "~> 4.2.0"

 spec.description  = <<-DESC
Reliable and convenient REST client, decidet for maximum economy with services descrription
						DESC



#TODO:
spec.homepage     = "http://HWWebclient"
spec.source       = { :git => "http://HWWebclient.git", :tag => "#{spec.version}" }


end
