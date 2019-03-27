
import Foundation

public enum HWWebClientError:Error {
	case parsing
	case unknown
	case alamofire(Error)
	case server(String)
	case `internal`
	case input
	case internalServer
	case noData

    func alertInfo() -> (title:String, text:String) {
        switch self {
        case .parsing:
            return ("Parsing Error", "Unable to parse server responce")
        case .alamofire(let e):
            return ("Communication Error", "\(e)")
        case .server(let str):
            return ("Server Error",  "\(str)")
        case .internal:
            return ("Internal Error", "Something went wrong...")
        case .input:
            return ("Input Error", "Invalid data entered")
		case .internalServer:
			return ("Error", "Internal Server Error")
		case .noData:
			return ("Error", "No data from server")

        case .unknown:
            fallthrough
        default:
            return ("Unknown Error", "Unexpected error occured")
        }

    }

    func description() -> String {
        return alertInfo().text
    }

	var localizedDescription: String {
		return description()
	}
}

