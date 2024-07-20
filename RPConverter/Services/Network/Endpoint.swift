//
//  Endpoint.swift
//  RPConverter
//
//  Created by Pavlo on 11.07.2024.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

enum EndpointError: Error, Equatable {
    case invalidURL
    case network(Error?)
    case invalidResponse(URLResponse?)
    case invalidData
    case validation(Error)
    case noInternetConnection
    
    var title: String {
        switch self {
        case .noInternetConnection:
            return "No network"
        default:
            return "Error"
        }
    }
    
    var description: String {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid"
        case .network(let error):
            return "A network error occurred: \(error?.localizedDescription ?? "Unknown error")"
        case .invalidResponse(let response):
            return "The server returned an invalid response: \(response.debugDescription)"
        case .invalidData:
            return "The data received from the server is invalid"
        case .validation(let error):
            return "A validation error occurred: \(error.localizedDescription)"
        case .noInternetConnection:
            return "Please check your internet connection"
        }
    }
}

extension EndpointError {
    static func == (lhs: EndpointError, rhs: EndpointError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.network(let lhsError), .network(let rhsError)):
            return (lhsError as NSError?) == (rhsError as NSError?)
        case (.invalidResponse(let lhsResponse), .invalidResponse(let rhsResponse)):
            return lhsResponse == rhsResponse
        case (.invalidData, .invalidData):
            return true
        case (.validation(let lhsError), .validation(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        case (.noInternetConnection, .noInternetConnection):
            return true
        default:
            return false
        }
    }
}

extension Endpoint {
    static func fxRates(request: CurrencyConversionRequest) -> Endpoint {
        return Endpoint(
            path: "/api/fx-rates",
            queryItems: [
                .init(name: "from", value: request.from.currency),
                .init(name: "to", value: request.to.currency),
                .init(name: "amount", value: "\(request.amount)")
            ]
        )
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "my.transfergo.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}
