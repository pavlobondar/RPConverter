//
//  RPCurrency.swift
//  RPConverter
//
//  Created by Pavlo on 11.07.2024.
//

import Foundation

enum RPCurrency: String, CaseIterable {
    case poland = "PLN"
    case germany = "EUR"
    case greatBritain = "GBP"
    case ukraine = "UAH"
    
    var maxAmountMessage: String {
        let sendingLimit = Int(sendingLimit)
        return "Maximum sending amount: \(sendingLimit) \(currency)"
    }
    
    var imageName: String {
        switch self {
        case .poland:
            return "poland"
        case .germany:
            return "germany"
        case .greatBritain:
            return "greatBritain"
        case .ukraine:
            return "ukraine"
        }
    }
    
    var name: String {
        switch self {
        case .poland:
            return "Polish zloty"
        case .germany:
            return "Euro"
        case .greatBritain:
            return "British Pound"
        case .ukraine:
            return "Hrivna"
        }
    }
    
    var country: String {
        switch self {
        case .poland:
            return "Poland"
        case .germany:
            return "Germany"
        case .greatBritain:
            return "Great Britan"
        case .ukraine:
            return "Ukraine"
        }
    }
    
    var currency: String {
        return rawValue
    }
    
    var sendingLimit: Double {
        switch self {
        case .poland:
            return 20000.0
        case .germany:
            return 5000.0
        case .greatBritain:
            return 1000.0
        case .ukraine:
            return 50000.0
        }
    }
}
