import Foundation

public struct ReceiptValidationRequest {
	///base-64 encoded
	public let receiptDataAsBase64:String
	
	/// Only used for receipts that contain auto-renewable subscriptions. Your app’s shared secret (a hexadecimal string)
	public let sharedSecret:String?
	
	public init(receiptDataAsBase64:String, sharedSecret:String? = nil) {
		self.receiptDataAsBase64 = receiptDataAsBase64
		self.sharedSecret = sharedSecret
	}
	
	public init(receiptData:Data, sharedSecret:String? = nil) {
		self.receiptDataAsBase64 = receiptData.base64EncodedString()
		self.sharedSecret = sharedSecret
	}
	
	public var json:[String:Any] {
		var params:[String:Any] = ["receipt-data":receiptDataAsBase64]
		if let password:String = self.sharedSecret {
			params["password"] = password
		}
		return params
	}
	
}
