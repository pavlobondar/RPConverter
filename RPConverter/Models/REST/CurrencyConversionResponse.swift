//
//  CurrencyConversionResponse.swift
//  RPConverter
//
//  Created by Pavlo on 11.07.2024.
//

import Foundation

struct CurrencyConversionResponse: Decodable {
    var from: RPCurrency
    var to: RPCurrency
    var fromAmount: Double
    var toAmount: Double
    let rate: Double
    
    var formattedRate: String? {
        return NumberFormatterService.getFormattedAmount(rate)
    }
    
    var formattedToAmount: String {
        guard fromAmount > 0, let toAmount = NumberFormatterService.getFormattedAmount(toAmount) else {
            return "0.00"
        }
        return toAmount
    }
    
    var exchangeRate: String {
        let rate = formattedRate ?? "\(rate)"
        return "1 \(from.currency) = \(rate) \(to.currency)"
    }
    
    enum CodingKeys: String, CodingKey {
        case from
        case to
        case rate
        case fromAmount
        case toAmount
    }
    
    init(from: RPCurrency,
         to: RPCurrency,
         rate: Double,
         fromAmount: Double,
         toAmount: Double) {
        self.from = from
        self.to = to
        self.rate = rate
        self.fromAmount = fromAmount
        self.toAmount = toAmount
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let from = try container.decode(String.self, forKey: .from).uppercased()
        self.from = .init(rawValue: from.uppercased()) ?? .poland
        
        let to = try container.decode(String.self, forKey: .to).uppercased()
        self.to = .init(rawValue: to.uppercased()) ?? .ukraine
        
        self.rate = try container.decode(Double.self, forKey: .rate)
        self.fromAmount = try container.decode(Double.self, forKey: .fromAmount)
        self.toAmount = try container.decode(Double.self, forKey: .toAmount)
    }
}

extension CurrencyConversionResponse {
    static func makeDefault() -> CurrencyConversionResponse {
        return .init(from: .poland,
                     to: .ukraine,
                     rate: 0.0,
                     fromAmount: 300.0,
                     toAmount: 0.0)
    }
}
