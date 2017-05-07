import Foundation

public protocol Cancellable {
	func cancel()
}

public protocol ReceiptValidationService {
	
	///It is not impossible for the completion to be called before the function has returned, just unusual
	func validate(request:ReceiptValidationRequest, completion: @escaping  (ReceiptValidationResponse?)->())->Cancellable
}

extension URLSessionDataTask : Cancellable {
}

public class AppleReceiptValidationService : ReceiptValidationService {
	
	public let host:Host
	
	private let urlSession:URLSession = URLSession(configuration: .default)
	
	public init(host:Host) {
		self.host = host
	}
	
	public enum Host {
		///Apple test sandbox service
		case test
		
		///Apple's real AppStore receipt validation
		case production
		
		public var rootURL:URL {
			switch self {
			case .test:
				return URL(string:"https://sandbox.itunes.apple.com/verifyReceipt")!
			case .production:
				return URL(string:"https://buy.itunes.apple.com/verifyReceipt")!
			}
		}
	}
	
	public func validate(request:ReceiptValidationRequest, completion:@escaping (ReceiptValidationResponse?)->())->Cancellable  {
		var urlRequest = URLRequest(url:host.rootURL)
		urlRequest.httpMethod = "POST"
		//um... if this fails...  quit before we try, or does this always suceed?
		urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: request.json, options: [])
		
		let task = urlSession.dataTask(with: urlRequest, completionHandler:{ (dataOrNil, urlResponseOrNil, errorOrNil) in
			guard let data:Data = dataOrNil
				else{
					completion(nil)
					return
			}
			guard let json = try? JSONSerialization.jsonObject(with: data, options: [])
				,let jsonDict = json as? [String:Any]
				else {
					completion(nil)
					return
			}
			//print(json)
			completion(ReceiptValidationResponse(json:jsonDict))
		})
		task.resume()
		return task
	}
}
