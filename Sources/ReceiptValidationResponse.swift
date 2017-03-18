import Foundation

public struct ReceiptValidationResponse {
	
	public let status:ReceiptStatus
	
	public let receipt:Receipt?
	
	//TODO: latest_receipt
	//TODO: latest_receipt_info
	
	public init?(json:[String:Any]) {
		guard let statusInt:Int = json["status"] as? Int
			,let status = ReceiptStatus(rawValue:statusInt)
			else { return nil }
		self.status = status
		if let receiptJson:[String:Any] = json["receipt"] as? [String:Any] {
			self.receipt = Receipt(json:receiptJson)
		} else {
			self.receipt = nil
		}
	}
	
}

public enum ReceiptStatus : Int, Error {
	// success
	case ReceiptValidated = 0
	
	// malformation errors
	case CannotReadJson = 21000
	case ReceiptDataPropertyMalformedOrMissing = 21002
	
	// invalid receipt
	case ReceiptCouldNotBeAuthenticated = 21003
	case SubscriptionExpired = 21006
	case SharedSecretDoesNotMatchAccount = 21004
	
	// server error
	case ServerNotAvailable = 21005
	
	// configuration errors
	case ReceiptIsTestButSentToProduction = 21007
	case ReceiptIsProductionButSentToTest = 21008
}
