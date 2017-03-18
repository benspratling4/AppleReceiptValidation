import Foundation

public struct Receipt {
	
	public let bundleIdentifier:String
	///assigned only in production, and not for Mac apps
	public let appID:String?
	public let appVersion:String
	///always use this date to validate
	public let creationDate:Date
	public let purchaseDate:Date
	public let transactionID:String
	public let productID:String
	public let quantity:Int
	public let cancellationDate:Date?
	public let subscriptionExpirationDate:Date?
	public let receiptExpirationDate:Date?
	public let originalPurchaseDate:Date?
	public let originalTransactionID:String?
	
	//public let originalAppVersion:String
	
	
	public let webOrderLineItemID:String?
	
	///not present for receipts created in the test environment
	public let buildNumber:String?
	
	public init?(json:[String:Any]) {
		guard let bundleID:String = json["bundle_id"] as? String
			,let appVersion:String = json["application_version"] as? String
			,let productID:String = json["product_id"] as? String
			,let transactionID:String = json["transaction_id"] as? String
			,let purchaseDateString:String = json["purchase_date"] as? String
			,let purchaseDate = Receipt.rfc3339Date(purchaseDateString)
			,let creationDateString:String = json["creation_date"] as? String
			,let creationDate = Receipt.rfc3339Date(creationDateString)
			,let quantityString = json["quantity"] as? String
			,let quantityInt:Int = Int(quantityString)
			else { return nil }
		self.bundleIdentifier = bundleID
		self.appVersion = appVersion
		self.purchaseDate = purchaseDate
		self.transactionID = transactionID
		self.appID = json["app_item_id"] as? String
		self.productID = productID
		self.creationDate = creationDate
		self.quantity = quantityInt
		self.webOrderLineItemID = json["web_order_line_item_id"] as? String
		self.buildNumber = json["version_external_identifier"] as? String
		self.originalTransactionID = json["original_transaction_id"] as? String
		if let cancellationString = json["cancellation_date"] as? String {
			self.cancellationDate = Receipt.rfc3339Date(cancellationString)
		} else {
			self.cancellationDate = nil
		}
		if let subscriptionExpirationInt:Int = json["expires_date"] as? Int {
			let seconds:Float64 = Float64(subscriptionExpirationInt)
			self.subscriptionExpirationDate = Date(timeIntervalSince1970:seconds)
		} else {
			self.subscriptionExpirationDate = nil
		}
		if let originalPurchaseString:String = json["original_purchase_date"] as? String {
			self.originalPurchaseDate = Receipt.rfc3339Date(originalPurchaseString)
		} else {
			self.originalPurchaseDate = nil
		}
		if let receiptExpirationString:String = json["expiration_date"] as? String {
			self.receiptExpirationDate = Receipt.rfc3339Date(receiptExpirationString)
		} else {
			self.receiptExpirationDate = nil
		}
	}
	
	private static let rfc3339DateFormatter:DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier:"en_US_POSIX")
		formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
		formatter.timeZone = TimeZone(secondsFromGMT:0)
			return formatter
		}()
	
	static func rfc3339Date(_ string:String)->Date? {
		return Receipt.rfc3339DateFormatter.date(from:string)
	}
	
}

public struct InAppPurchaseReceipt {
	
	
}

