//
//  NetworkServiceTests.swift
//  TransferGo
//
//  Created by MAT on 25/09/2025.
//

import XCTest
@testable import TransferGo

class NetworkServiceTests: XCTestCase {
    
    // MARK: - Network Error Tests
    
    func testNetworkErrorTypes() {
        // Given
        let networkError = NetworkError.invalidURL
        let responseError = NetworkError.invalidResponse
        let decodingError = NetworkError.decodingError
        
        // When & Then
        XCTAssertNotNil(networkError)
        XCTAssertNotNil(responseError)
        XCTAssertNotNil(decodingError)
    }
    
    // MARK: - URL Components Tests
    
    func testURLComponentsCreation() {
        // Given
        let baseURL = "https://my.transfergo.com/api"
        let endpoint = "/fx-rates"
        
        // When
        let urlComponents = URLComponents(string: "\(baseURL)\(endpoint)")
        
        // Then
        XCTAssertNotNil(urlComponents)
        XCTAssertEqual(urlComponents?.host, "my.transfergo.com")
        XCTAssertEqual(urlComponents?.path, "/api/fx-rates")
    }
    
    func testQueryParameters() {
        // Given
        let from = "PLN"
        let to = "EUR"
        let amount: Float = 100.0
        
        // When
        var urlComponents = URLComponents(string: "https://my.transfergo.com/api/fx-rates")
        urlComponents?.queryItems = [
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "to", value: to),
            URLQueryItem(name: "amount", value: String(amount))
        ]
        
        // Then
        XCTAssertNotNil(urlComponents?.url)
        XCTAssertEqual(urlComponents?.queryItems?.count, 3)
        XCTAssertEqual(urlComponents?.queryItems?.first?.name, "from")
        XCTAssertEqual(urlComponents?.queryItems?.first?.value, "PLN")
    }
}
