import Foundation

public struct AppReceipt {
	public let bundleIdentifier:String
	public let appVersion:String
	public let creationDate:Date?
	public let receiptExpirationDate:Date?
	public let originalAppVersion:String?
	public let inApp:[InAppReceipt]
	
	public init?(json:[String:Any]) {
		guard let bundleID:String = json["bundle_id"] as? String
		,let appVersion:String = json["application_version"] as? String
			else {
				return nil
		}
		self.bundleIdentifier = bundleID
		self.appVersion = appVersion
		creationDate = (json["creation_date"] as? String).flatMap(InAppReceipt.rfc3339Date)
		
		receiptExpirationDate = (json["expiration_date"] as? String).flatMap(InAppReceipt.rfc3339Date)
		inApp = (json["in_app"] as? [[String:Any]] ?? []).flatMap(InAppReceipt.init(json:))
		originalAppVersion = json["original_application_version"] as? String
	}
	
}


public struct InAppReceipt {
	///assigned only in production, and not for Mac apps
	public let appID:String?
	public let purchaseDate:Date
	public let transactionID:String
	public let productID:String
	public let quantity:Int
	public let cancellationDate:Date?
	public let subscriptionExpirationDate:Date?
	public let originalPurchaseDate:Date?
	public let originalTransactionID:String?
	
	public let webOrderLineItemID:String?
	
	///not present for receipts created in the test environment
	public let buildNumber:String?
	
	public init?(json:[String:Any]) {
		guard let productID:String = json["product_id"] as? String
			,let transactionID:String = json["transaction_id"] as? String
			,let purchaseDateString:String = json["purchase_date"] as? String
			,let purchaseDate = InAppReceipt.rfc3339Date(purchaseDateString)
			,let quantityString = json["quantity"] as? String
			,let quantityInt:Int = Int(quantityString)
			else { return nil }
		//
		self.purchaseDate = purchaseDate
		self.transactionID = transactionID
		self.appID = json["app_item_id"] as? String
		self.productID = productID
		self.quantity = quantityInt
		self.webOrderLineItemID = json["web_order_line_item_id"] as? String
		self.buildNumber = json["version_external_identifier"] as? String
		self.originalTransactionID = json["original_transaction_id"] as? String
		
		cancellationDate = (json["cancellation_date"] as? String).flatMap(InAppReceipt.rfc3339Date)
		subscriptionExpirationDate = (json["expires_date"] as? String).flatMap(InAppReceipt.rfc3339Date)
		originalPurchaseDate = (json["original_purchase_date"] as? String).flatMap(InAppReceipt.rfc3339Date)
	}
	
	private static let rfc3339DateFormatter:DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier:"en_US_POSIX")
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
		//formatter.timeZone = TimeZone(secondsFromGMT:0)
			return formatter
		}()
	
	static func rfc3339Date(_ string:String)->Date? {
		return InAppReceipt.rfc3339DateFormatter.date(from:string)
	}
	
}

