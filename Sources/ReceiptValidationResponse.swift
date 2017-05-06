import Foundation

public struct ReceiptValidationResponse {
	
	public let status:ReceiptStatus
	
	public let receipt:AppReceipt?
	
	public let latestReceiptData:Data?
	
	public let latestReceipts:[InAppReceipt]
	
	public init?(json:[String:Any]) {
		guard let statusInt:Int = json["status"] as? Int
			,let status = ReceiptStatus(rawValue:statusInt)
			else { return nil }
		self.status = status
		receipt = (json["receipt"] as? [String:Any]).flatMap{AppReceipt(json:$0)}
		latestReceipts = (json["latest_receipt_info"] as? [[String:Any]])?.flatMap{InAppReceipt(json:$0)} ?? []
		latestReceiptData = (json["latest_receipt"] as? String).flatMap({ (base64String) -> Data? in
			return Data(base64Encoded: base64String)
		})
	}	
}


public enum ReceiptStatus : Int, Error {
	/// success
	case receiptValidated = 0
	
	/// malformation errors
	case cannotReadJson = 21000
	case receiptDataPropertyMalformedOrMissing = 21002
	
	/// invalid receipt
	case receiptCouldNotBeAuthenticated = 21003
	case subscriptionExpired = 21006
	case sharedSecretDoesNotMatchAccount = 21004
	
	/// server error
	case serverNotAvailable = 21005
	
	/// configuration errors
	case receiptIsTestButSentToProduction = 21007
	case receiptIsProductionButSentToTest = 21008
}
