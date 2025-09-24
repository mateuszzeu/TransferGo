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
    @Published var errorMessage: String = ""
    @Published var limitExceeded: Bool = false
    @Published var limitMessage: String = ""
    
    private let networkService = NetworkService()
    let currencyService = CurrencyService()
    
    init() {
        self.fromCurrency = currencyService.getDefaultFromCurrency()
        self.toCurrency = currencyService.getDefaultToCurrency()
        Task {
            await loadExchangeRate()
        }
    }
    
    func loadExchangeRate() async {
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
        
        if newAmount.isEmpty || newAmount == "0" {
            fromAmount = "0"
            toAmount = "0"
            limitExceeded = false
            limitMessage = ""
            return
        }
        
        if !validateLimit(newAmount) {
            limitExceeded = true
            limitMessage = "Maximum sending amount: \(Int(fromCurrency.limit)) \(fromCurrency.code)"
            return
        }
        
        limitExceeded = false
        limitMessage = ""
        
        Task {
            await loadExchangeRate()
        }
    }
    
    func updateToAmount(_ newAmount: String) {
        toAmount = newAmount
        
        guard let newAmountValue = Double(newAmount), exchangeRate != 0 else {
            fromAmount = "0"
            limitExceeded = false
            limitMessage = ""
            return
        }
        
        let calculatedFromAmount = newAmountValue / exchangeRate
        
        fromAmount = String(format: "%.2f", calculatedFromAmount)
        
        if !validateLimit(fromAmount) {
            limitExceeded = true
            limitMessage = "Maximum sending amount: \(Int(fromCurrency.limit)) \(fromCurrency.code)"
        } else {
            limitExceeded = false
            limitMessage = ""
        }
    }
    
    func validateLimit(_ amount: String) -> Bool {
        guard let amountValue = Double(amount) else { return false }
        return amountValue <= fromCurrency.limit
    }
}
