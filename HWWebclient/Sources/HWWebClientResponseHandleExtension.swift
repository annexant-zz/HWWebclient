
import Foundation
import Alamofire
import SwiftyJSON

public extension HWWebClient {
	
	func jsonFromObject(_ object:Any?, path:[JSONSubscriptType]? = nil) -> JSON? {
		
		var result:JSON? = nil
		
		if let data = object as? JSON {
			result = data
		} else if let data = object as? NSData {
			result = JSON(data)
		} else if let data = object as? String {
			result = JSON.init(parseJSON: data)
		} else if let data = object {
			result = JSON(data)
		}
		
		if let pathForModel = path, let json = result {
			result = json[pathForModel]
		}
		return result
	}
	
    func createCompletionHandler(
                           _ path:String,
                           succsess:@escaping HWWSuccsessBlock,
                           failure:HWWFailureHandler?) -> ((DataResponse<Any>) -> Void) {

		let result:((DataResponse<Any>) -> Void) = { response -> Void in
			
			self.printResponseDebugInfo(response)

			let responseData = self.jsonFromObject(response.data)
			if let error = self.config.errorFromResponse(response, data: responseData) {
				self.config.printDebugInfo("ERROR FROM SERVER:\n\t- path: \(path):\n\t- ERROR: \(error)")
				self.handleError(error, handler: failure)
				return
			}
			
            switch response.result {
            case .success:
                let data = response.value as? [String: AnyObject]
				succsess(data);
                break;
            case .failure(let e):
					self.handleError(HWWebClientError.alamofire(e), handler: failure)
                break;
            }
        }
        return result
    }
    
    func handleError(_ incomingError:HWWebClientError, handler:HWWFailureHandler?) {
        self.config.printDebugError("handleError:" + incomingError.localizedDescription)
        let h = handler ?? {_ in self.config.defaultErrorHandler(incomingError)}
        h(incomingError)
    }
    
	@discardableResult func handleResponse<T>(_ object:Any?,
	                                          modelType:T.Type,
	                                          path:[JSONSubscriptType]? = nil,
	                                          successHandler:@escaping HWWSuccsessHandler<T>,
	                                          failureHandler:HWWFailureHandler?) -> T? where T:Codable {
        if let json = jsonFromObject(object, path: path) {
			do {
				let jsonData = try json.rawData()
				let decoder = JSONDecoder()
				let result:T = try decoder.decode(modelType, from: jsonData)
				successHandler(result)
				return result
			} catch {
				self.config.printDebugInfo("\(error)")
				handleError(HWWebClientError.parsing, handler: failureHandler)
				return nil
			}
        }
		
        return nil
    }
	
	@discardableResult func handleResponseUnwrapped<T>(_ object:Any?,
											  modelType:T.Type,
											  path:[JSONSubscriptType]? = nil,
											  successHandler:@escaping HWWSuccsessHandlerUnwrapped<T>,
											  failureHandler:HWWFailureHandler?) -> T? where T:Codable {
		return handleResponse(object,
							  modelType: modelType,
							  path: path,
							  successHandler: { (wrapped) in
								guard let result = wrapped else {
									self.handleError(HWWebClientError.parsing, handler: failureHandler)
									return
								}
								successHandler(result)
		},
							  failureHandler: failureHandler)
	}

	func printResponseDebugInfo(_ response: DataResponse<Any>) {
		if config.config.printDebugInfo {
			var method = "<Unknown Method>"
			var value = "<no value>"
			var responseStatus = "<Unknown Status>"
			var responseData = "<no data>"
			var url = "<unknown url>"
			var error = ""
			
			switch response.result {
			case .success(let val) :
				responseStatus = "SUCCESS"
				value = "\(val)"
			case .failure(let err):
				responseStatus = "FAILURE"
				error = "\(err)"
			}
			
			if let r = response.request {
				if let m = r.httpMethod {
					method = "\(m)"
				}
				
				if let u = r.url {
					url = "\(u)"
				}
			}
			
			if let data = response.data {
				responseData = String.init(data: data, encoding: String.Encoding.ascii) ?? "<binary data>"
			}
			
			var str = "RESPONSE:\(responseStatus):\(method):\(url):\n    - value:\(value)\n    - data:\(responseData)"
			if error.count > 0 {
				str += "\n    - error:\(error)"
			}
			
			self.config.printDebugInfo(str)
		}
	}

}


