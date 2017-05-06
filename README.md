# AppleReceiptValidation

Used for validating in-app purchase receipts with Apple


## Use

1. Create a persistent `AppleReceiptValidationService` with either the `.test` or `.production` host.  `.test` == "sandbox".

	let service:AppleReceiptValidationService = AppleReceiptValidationService(host:.production)

2. Obtain the receipt from the app using the `Bundle`'s `.appStoreReceiptURL` property 

	guard let url:URL = Bundle.main.appStoreReceiptURL
		,let receiptData:Data = try? Data(contentsOf: url)
		else {
			return
	}

3. Create a receipt validation request

let request = ReceiptValidationRequest(receiptData:receiptData)

A variant exists for data which has already been transformed into base-64.

If you intend to validate an auto-renewable subscription, include the shared secret, as a string.

	let request = ReceiptValidationRequest(receiptData:receiptData, sharedSecret:"i4u65cni534m57xo84")

4. Get a task object 

	let task:Cancellable = service.validate(request:request) { responseOrNil in
		guard let response = responseOrNil else {
			//Network likely failed
			return
		}
		if response.status != .receiptValidated {
			//other failure
			return
		}
		//check attributes of the receipt and in-app receipts as needed
	}
