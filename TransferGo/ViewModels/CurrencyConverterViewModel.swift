//
//  CurrencyConverterViewModel.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//
import Combine
import Foundation

@MainActor
class CurrencyConverterViewModel: ObservableObject {
    @Published var fromCurrency: Currency
    @Published var toCurrency: Currency
    @Published var fromAmount: String = "300.00"
    @Published var toAmount: String = ""
    @Published var exchangeRate: Double = 0.0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let networkService = NetworkService()
    private let currencyService = CurrencyService()
    
    init() {
        self.fromCurrency = currencyService.getDefaultFromCurrency()
        self.toCurrency = currencyService.getDefaultToCurrency()
        Task {
            await loadExchangeRate()
        }
    }
    
    func loadExchangeRate() async {
        isLoading = true
        errorMessage = ""
        
        do {
            let amount = Double(fromAmount) ?? 0.0
            let rate = try await networkService.getExchangeRate(
                from: fromCurrency.code,
                to: toCurrency.code,
                amount: amount
            )
            
            exchangeRate = rate.rate
            toAmount = String(format: "%.2f", rate.toAmount)
            
        } catch {
            errorMessage = "Error loading exchange rate"
        }
        
        isLoading = false
    }
    
    func swapCurrencies() {
        let tempCurrency = fromCurrency
        fromCurrency = toCurrency
        toCurrency = tempCurrency
        
        let tempAmount = fromAmount
        fromAmount = toAmount
        toAmount = tempAmount
        
        Task {
            await loadExchangeRate()
        }
    }
    
    func updateFromAmount(_ newAmount: String) {
        fromAmount = newAmount
        Task {
            await loadExchangeRate()
        }
    }
    
    func updateToAmount(_ newAmount: String) {
        toAmount = newAmount
        
        Task {
            await loadExchangeRate()
            
            if let toAmountValue = Double(newAmount), exchangeRate > 0 {
                let fromAmountValue = toAmountValue / exchangeRate
                fromAmount = String(format: "%.2f", fromAmountValue)
            }
        }
    }
}
