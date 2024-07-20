//
//  NetworkService.swift
//  RPConverter
//
//  Created by Pavlo on 11.07.2024.
//

import Foundation
import Combine

protocol ResponseValidator {
    func validate(_ response: HTTPURLResponse) throws
}

enum ResponseValidationError: Error, Equatable {
    case unacceptableCode(Int)
}

struct StatusCodeValidator: ResponseValidator {
    func validate(_ response: HTTPURLResponse) throws {
        guard (200...299).contains(response.statusCode) else {
            throw ResponseValidationError.unacceptableCode(response.statusCode)
        }
    }
}

typealias DataLoaderHandler = (Result<Data, EndpointError>) -> Void
typealias CurrencyConversionPublisher = AnyPublisher<CurrencyConversionResponse, EndpointError>

protocol NetworkServiceProtocol {
    func converterPublisher(endpoint: Endpoint) -> CurrencyConversionPublisher
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let responseValidator: ResponseValidator
    
    init(session: URLSession,
         decoder: JSONDecoder,
         responseValidator: ResponseValidator) {
        self.session = session
        self.decoder = decoder
        self.responseValidator = responseValidator
    }
    
    func converterPublisher(endpoint: Endpoint) -> CurrencyConversionPublisher {
        guard let url = endpoint.url else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { [responseValidator] data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw EndpointError.invalidResponse(response)
                }
                try responseValidator.validate(httpResponse)
                return data
            }
            .decode(type: CurrencyConversionResponse.self, decoder: decoder)
            .mapError { error -> EndpointError in
                return error as? EndpointError ?? .network(error)
            }
            .eraseToAnyPublisher()
    }
}

extension NetworkService {
    static func makeDefault() -> NetworkService {
        let session = URLSession.shared
        let decoder = JSONDecoder()
        let responseValidator = StatusCodeValidator()
        
        return .init(session: session,
                     decoder: decoder,
                     responseValidator: responseValidator)
    }
}
