//
//  CountryCellViewModel.swift
//  RPConverter
//
//  Created by Pavlo on 11.07.2024.
//

import Foundation

final class CountryCellViewModel {
    private let currency: RPCurrency
    
    var image: String {
        return currency.imageName
    }
    
    var title: String {
        return currency.country
    }
    
    var subtitle: String {
        return "\(currency.name) • \(currency.currency)"
    }
    
    init(currency: RPCurrency) {
        self.currency = currency
    }
}
