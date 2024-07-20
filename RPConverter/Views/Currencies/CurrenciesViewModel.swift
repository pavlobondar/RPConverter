//
//  CurrenciesViewModel.swift
//  RPConverter
//
//  Created by Pavlo on 16.07.2024.
//

import Foundation
import Combine

final class CurrenciesViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable>
        
    @Published var currencies: [RPCurrency]
    @Published var query: String = ""
    
    init(currencies: [RPCurrency] = RPCurrency.allCases) {
        self.currencies = currencies
        self.cancellables = []
        
        $query
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] query in
                guard let self = self, !query.isEmpty else {
                    return RPCurrency.allCases
                }
                
                return self.currencies.filter {
                    let country = $0.country.range(of: query, options: .caseInsensitive)
                    let currency = $0.currency.range(of: query, options: .caseInsensitive)
                    return country != nil || currency != nil
                }
            }
            .sink(receiveValue: { [weak self] currencies in
                self?.currencies = currencies
            })
            .store(in: &cancellables)
    }
}
