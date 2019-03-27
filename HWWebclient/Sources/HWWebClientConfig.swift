
import UIKit
import Alamofire
import SwiftyJSON

fileprivate typealias SELF = HWWebClientConfigInfo
open class HWWebClientConfigInfo {
    //MARK: Config

	class Config {
		var printDebugInfo: Bool = true
		var printDebugError: Bool = true
		var basicAuthLogin: String = ""
		var basicAuthPassword: String = ""
		var debugPrefix = "HWWC:"
		static var defaultHeaders: HTTPHeaders = ["Accept":" application/json","Content-Type":"application/json"]
	}


	var config = Config()

	var headers: HTTPHeaders = Config.defaultHeaders

	func setHeader(_ key: String, value: String? = nil) {
		headers[key] = value
	}

	func customizeRequest(_ request:DataRequest) {
        request.validate(statusCode: 200..<300)
    }
    
    func defaultErrorHandler(_ error:HWWebClientError) {
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
    
    func errorFromData(_ data:JSON) -> HWWebClientError? {
        printDebugInfo(":errorFromResponse:Not customized, always returns nil (no error)")
        return nil
    }
    
    func errorFromResponse(_ response:DataResponse<Any>, data:JSON? = nil) -> HWWebClientError? {

		if let d = data, let error = errorFromData(d) {
			return error
		}
		
        if let e = response.result.error {
            return HWWebClientError.alamofire(e)
        }
        
        return nil
    }
    
    func printDebugInfo(_ info:String) {
        if config.printDebugInfo {
            print(config.debugPrefix + info)
        }
    }
    
    func printDebugError(_ info:String) {
        if config.printDebugError {
            print("ERROR:" + config.debugPrefix + info)
        }
    }
}
