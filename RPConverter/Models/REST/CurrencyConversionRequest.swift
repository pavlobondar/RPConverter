//
//  CurrencyConversionRequest.swift
//  RPConverter
//
//  Created by Pavlo on 11.07.2024.
//

import Foundation

struct CurrencyConversionRequest {
    let from: RPCurrency
    let to: RPCurrency
    let amount: Double
    
    init(from: RPCurrency,
         to: RPCurrency,
         amount: Double) {
        self.from = from
        self.to = to
        self.amount = amount
    }
}
