//
//  NetworkService.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//
import Foundation

class NetworkService {
    private let baseURL = "https://my.transfergo.com/api"
    
    func getExchangeRate(from: String, to: String, amount: Float) async throws -> ExchangeRate {
        var urlComponents = URLComponents(string: "\(baseURL)/fx-rates")
        urlComponents?.queryItems = [
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "to", value: to),
            URLQueryItem(name: "amount", value: String(amount))
        ]
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let exchangeRate = try JSONDecoder().decode(ExchangeRate.self, from: data)
        return exchangeRate
    }
}
