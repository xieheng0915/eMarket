//
//  StripeClient.swift
//  eMarket
//
//  Created by Xieheng on 2020/03/21.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class StripeClient {
    
    static let sharedClient = StripeClient()
    
    var baseURLString: String? = nil
    
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func createAndConfirmPayment(_ token: STPToken, amount: Int, completio: @escaping (_ error: Error) -> Void) {
        
        let url = self.baseURL.appendingPathComponent("charge")
        
        let params: [String : Any] = ["stripeToken" : token.tokenId, "amount" : amount, "description" : Constats.defaultDescription, "currency" : Constats.defaultCurrency]
     
        //TODO: check Alamofire latest update
        
        AF.request(url, method: .post, parameters: params).validate(statusCode: 200..<300).response {(response) in
            
            switch response.result {
            case .success( _):
                print("Payment successful")
            case .failure(let  error):
                print("error processing the payment", error.localizedDescription)
            }
            
        }
        
    }
    
}
