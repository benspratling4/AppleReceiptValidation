import Foundation

public struct ReceiptValidationRequest {
	///base-64 encoded
	public let receiptDataAsBase64:String
	
	/// Only used for receipts that contain auto-renewable subscriptions. Your app’s shared secret (a hexadecimal string)
	public let password:String?
	
	public init(receiptDataAsBase64:String, password:String? = nil) {
		self.receiptDataAsBase64 = receiptDataAsBase64
		self.password = password
	}
	
	public init(receiptData:Data, password:String? = nil) {
		self.receiptDataAsBase64 = receiptData.base64EncodedString()
		self.password = password
	}
	
	public var json:[String:Any] {
		var params:[String:Any] = ["receipt-data":receiptDataAsBase64]
		if let password = self.password {
			params["password"] = password
		}
		return params
	}
	
}
