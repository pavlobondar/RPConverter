//
//  ConverterViewModel.swift
//  RPConverter
//
//  Created by Pavlo on 11.07.2024.
//

import Foundation
import Combine

final class ConverterViewModel: ObservableObject {
    
    private let networkService: NetworkServiceProtocol
    
    private var cancellables: Set<AnyCancellable>
    
    @Published private var selectedCurrencyRole: CurrencyRole?
    
    @Published var conversion: CurrencyConversionResponse
    @Published var validation: CurrencyValidationResult
    @Published var isModalActive: Bool
    @Published var selectedCurrency: RPCurrency?
    
    @Published var baseCurrency: RPCurrency
    @Published var targetCurrency: RPCurrency
    @Published var amount: Double
    
    @Published var toast: Toast? = nil
    
    init(networkService: NetworkServiceProtocol = NetworkService.makeDefault()) {
        self.networkService = networkService
        self.cancellables = []
        
        self.conversion = .makeDefault()
        self.validation = .valid
        self.isModalActive = false
        
        self.baseCurrency = .poland
        self.targetCurrency = .ukraine
        self.amount = 300.0
        
        isAmountValidPublisher
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] validation in
                self?.validation = validation
                switch validation {
                case .exceedsMax:
                    break
                case .zeroAmount:
                    self?.conversion.fromAmount = 0.0
                case .valid:
                    self?.convertCurrency()
                }
            }
            .store(in: &cancellables)
        
        $selectedCurrencyRole
            .receive(on: RunLoop.main)
            .sink { [weak self] role in
                switch role {
                case .base, .target:
                    self?.isModalActive.toggle()
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
        
        $selectedCurrency
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] currency in
                switch self?.selectedCurrencyRole {
                case .base:
                    self?.baseCurrency = currency
                case .target:
                    self?.targetCurrency = currency
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest3($baseCurrency, $targetCurrency, isAmountValidPublisher)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map { [weak self] baseCurrency, targetCurrency, isAmountValid in
                self?.conversion.from = baseCurrency
                self?.conversion.to = targetCurrency
                
                return isAmountValid == .valid
            }
            .filter { isAmountValid in
                return isAmountValid
            }
            .sink(receiveValue: { [weak self] _ in
                self?.convertCurrency()
            })
            .store(in: &cancellables)
    }
    
    private func convertCurrency() {
        let request: CurrencyConversionRequest = .init(from: baseCurrency,
                                                       to: targetCurrency,
                                                       amount: amount)
        networkService.converterPublisher(endpoint: .fxRates(request: request))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.toast = .init(error: error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] conversion in
                self?.conversion = conversion
            }
            .store(in: &cancellables)
    }
    
    func updateBaseCurrency() {
        selectedCurrencyRole = .base
    }
    
    func updateTargetCurrency() {
        selectedCurrencyRole = .target
    }
    
    func switchCurrencies() {
        let fromCurrency = baseCurrency
        let toCurrency = targetCurrency
        baseCurrency = toCurrency
        targetCurrency = fromCurrency
    }
    
    func updateConnectionState(isActive: Bool) {
        guard !isActive else { return }
        toast = .init(error: .noInternetConnection)
    }
}

// MARK: - Publishers
extension ConverterViewModel {
    enum CurrencyValidationResult: Error {
        case zeroAmount
        case exceedsMax
        case valid
    }
    
    enum CurrencyRole {
        case base
        case target
    }
    
    private var isAmountNonZeroPublisher: AnyPublisher<Bool, Never> {
        $amount
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0 > 0.0 }
            .eraseToAnyPublisher()
    }
    
    private var isAmountWithinLimitPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($amount, $baseCurrency)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map { amount, baseCurrency in
                return amount <= baseCurrency.sendingLimit
            }
            .eraseToAnyPublisher()
    }
    
    private var isAmountValidPublisher: AnyPublisher<CurrencyValidationResult, Never> {
        Publishers.CombineLatest(isAmountNonZeroPublisher, isAmountWithinLimitPublisher)
            .map { isAmountNonZero, isAmountWithinLimit in
                if !isAmountNonZero {
                    return .zeroAmount
                } else if !isAmountWithinLimit {
                    return .exceedsMax
                } else {
                    return .valid
                }
            }
            .eraseToAnyPublisher()
    }
}
