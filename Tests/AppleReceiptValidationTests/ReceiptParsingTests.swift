//
//  ReceiptParsingTests.swift
//  AppleReceiptValidation
//
//  Created by Ben Spratling on 4/25/17.
//
//

import Foundation
import XCTest
@testable import AppleReceiptValidation


let alternateReceipt = "{\"receipt\":{\"original_purchase_date_pst\": \"2013-08-06 11:58:04 America/Los_Angeles\",\"unique_identifier\": \"------------\",\"original_transaction_id\": \"----------\",\"expires_date\": \"1376129825000\",\"transaction_id\": \"------------\",\"quantity\": \"1\",\"product_id\": \"subscription\",\"item_id\": \"--------\",\"bid\": \"com.--------\",\"unique_vendor_identifier\": \"---------\",\"web_order_line_item_id\": \"---------\",\"bvrs\": \"2.0\",\"expires_date_formatted\": \"2013-08-10 10:17:05 Etc/GMT\",\"purchase_date\": \"2013-08-10 10:12:05 Etc/GMT\",\"purchase_date_ms\": \"1376129525000\",\"expires_date_formatted_pst\": \"2013-08-10 03:17:05 America/Los_Angeles\",\"purchase_date_pst\": \"2013-08-10 03:12:05 America/Los_Angeles\",\"original_purchase_date\": \"2013-08-06 18:58:04 Etc/GMT\",\"original_purchase_date_ms\": \"1375815484000\" },\"latest_expired_receipt_info\":{ \"original_purchase_date_pst\": \"2013-08-06 11:58:04 America/Los_Angeles\",\"unique_identifier\": \"-------\",\"original_transaction_id\": \"-\",\"expires_date\": \"1376129825000\",\"transaction_id\": \"-\",\"quantity\": \"1\",\"product_id\": \"subscription\",\"item_id\": \"-\",\"bid\": \"com.-\",\"unique_vendor_identifier\": \"--\",\"web_order_line_item_id\": \"-\",\"bvrs\": \"2.0\",\"expires_date_formatted\": \"2013-08-10 10:17:05 Etc/GMT\",\"purchase_date\": \"2013-08-10 10:12:05 Etc/GMT\",\"purchase_date_ms\": \"1376129525000\",\"expires_date_formatted_pst\": \"2013-08-10 03:17:05 America/Los_Angeles\",\"purchase_date_pst\": \"2013-08-10 03:12:05 America/Los_Angeles\",\"original_purchase_date\": \"2013-08-06 18:58:04 Etc/GMT\",\"original_purchase_date_ms\": \"1375815484000\" },\"status\": 21006 }"


class ReceiptParsingTests : XCTestCase {
	func testBase64() {
		guard let data:Data = alternateReceipt.data(using: .utf8) else {
			XCTFail()
			return
		}
		guard let _ = try? JSONSerialization.jsonObject(with: data, options: []) else {
			XCTFail()
			return
		}
	}
	
	func testResponse() {
		guard let data:Data = alternateReceipt.data(using: .utf8) else {
			XCTFail()
			return
		}
		guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
			,let json = jsonObject as? [String:Any] else {
			XCTFail()
			return
		}
		guard let _ = ReceiptValidationResponse(json: json) else {
			XCTFail()
			return
		}
	}
	
}


