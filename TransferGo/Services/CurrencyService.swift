//
//  CurrencyService.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//
import Foundation

class CurrencyService {
    let supportedCurrencies: [Currency] = [
        Currency(
            id: UUID(),
            code: "PLN",
            name: "Poland",
            country: "Polska",
            flag: "PLN",
            limit: 20000
        ),
        Currency(
            id: UUID(),
            code: "EUR",
            name: "Germany",
            country: "Niemcy",
            flag: "EUR",
            limit: 5000
        ),
        Currency(
            id: UUID(),
            code: "GBP",
            name: "Great Britain",
            country: "Wielka Brytania",
            flag: "GBP",
            limit: 1000
        ),
        Currency(
            id: UUID(),
            code: "UAH",
            name: "Ukraine",
            country: "Ukraina",
            flag: "UAH",
            limit: 50000
        )
    ]
    
    func getDefaultFromCurrency() -> Currency {
        return supportedCurrencies[0]
    }
    
    func getDefaultToCurrency() -> Currency {
        return supportedCurrencies[3]
    }
    
    func getDefaultAmount() -> Double {
        return 300.0
    }
}
