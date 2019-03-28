
import UIKit
import Alamofire
import SwiftyJSON

fileprivate typealias SELF = HWWebClientConfigInfo
open class HWWebClientConfigInfo {
    //MARK: Config

	public class Config {
		public static let defaultHeaders: HTTPHeaders = ["Accept":" application/json","Content-Type":"application/json"]

		public var printDebugInfo: Bool = true
		public var printDebugError: Bool = true
		public var basicAuthLogin: String = ""
		public var basicAuthPassword: String = ""
		public var debugPrefix = "HWWC:"
	}


	public var config = Config()
	public var headers: HTTPHeaders = Config.defaultHeaders

	public init() {
	}

	public func setHeader(_ key: String, value: String? = nil) {
		headers[key] = value
	}

	public func customizeRequest(_ request:DataRequest) {
        request.validate(statusCode: 200..<300)
    }
    
    public func defaultErrorHandler(_ error:HWWebClientError) {
        //TODO: At least hiding of a HUD should be made here as well.
		DispatchQueue.main.async {
			if let vc = UIApplication.shared.keyWindow?.rootViewController {
				let (title, message) = error.alertInfo()
				let alert:UIAlertController = UIAlertController(title: title,
																message: message,
																preferredStyle: .alert);
				let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
				alert.addAction(cancelAction)
				vc.present(alert, animated: true, completion: nil);
			}
		}
    }
    
    public func errorFromData(_ data:JSON) -> HWWebClientError? {
        printDebugInfo(":errorFromResponse:Not customized, always returns nil (no error)")
        return nil
    }
    
    open func errorFromResponse(_ response:DataResponse<Any>, data:JSON? = nil) -> HWWebClientError? {

		if let d = data, let error = errorFromData(d) {
			return error
		}
		
        if let e = response.result.error {
            return HWWebClientError.alamofire(e)
        }
        
        return nil
    }
    
    public func printDebugInfo(_ info:String) {
        if config.printDebugInfo {
            print(config.debugPrefix + info)
        }
    }
    
    public func printDebugError(_ info:String) {
        if config.printDebugError {
            print("ERROR:" + config.debugPrefix + info)
        }
    }
}
