//
//  HelperFunctions.swift
//  eMarket
//
//  Created by Xieheng on 2020/02/15.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import Foundation

func covertToCurrency(_ number: Double) -> String {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    currencyFormatter.positivePrefix = "¥"
    currencyFormatter.maximumFractionDigits = 2
    
    return currencyFormatter.string(from: NSNumber(value: number))!
    
}
