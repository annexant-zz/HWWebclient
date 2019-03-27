
import Foundation
import UIKit
import Alamofire
import SwiftyJSON


open class HWWebClient {

	public typealias HWWSuccsessBlock = (_ object:Any?) ->Void
	public typealias HWWSuccsessHandler<T> = (_ object:T?) ->Void
	public typealias HWWSuccsessHandlerUnwrapped<T> = (_ object:T) ->Void
	public typealias HWWFailureHandler = (_ error:HWWebClientError) ->Void

    var config:HWWebClientConfigInfo
    
    init(_ config:HWWebClientConfigInfo) {
        self.config = config
    }
    
    func query(_ method:HTTPMethod,
               path:URLConvertible,
               parameters:Parameters?,
               succsess:@escaping HWWSuccsessBlock,
               failure:HWWFailureHandler? ) {
        
		logQuery(method: method, path: path, parameters: parameters)
        let completion = self.createCompletionHandler(path as! String, succsess: succsess, failure: failure)
        let request = Alamofire.request(path,
                                        method: method,
                                        parameters: parameters,
//TODO: if you change this from URLEncoding.default, params will not be transmitted through the url
//										encoding: JSONEncoding.default,
                                        headers: config.headers)
        config.customizeRequest(request)
        request.responseJSON(completionHandler: completion)
    }
    
	func post(_ path:String, parameters:Parameters?, success:@escaping HWWSuccsessBlock, failure:HWWFailureHandler?) {
		query( .post, path: path, parameters: parameters, succsess: success, failure: failure)
	}
	
	func delete(_ path:String, parameters:Parameters?, success:@escaping HWWSuccsessBlock, failure:HWWFailureHandler?) {
		query( .delete, path: path, parameters: parameters, succsess: success, failure: failure)
	}
	
    func get(_ path:String, parameters:Parameters? = nil, success:@escaping HWWSuccsessBlock, failure:HWWFailureHandler?) {
        query(.get, path: path, parameters: parameters, succsess: success, failure: failure)
    }
	
	func logQuery(method:HTTPMethod, path:URLConvertible, parameters:Parameters?) {
		var s = "\n\n\(method):\(path)"
		if let p = parameters {
			s += "\n - PARAMS:\(p)"
		}
		s += "\n\n"
		config.printDebugInfo(s)

	}
}
