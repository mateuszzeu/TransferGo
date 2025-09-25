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
    
    @Published var isFromChangeCausedByAPI: Bool = false
    @Published var isToChangeCausedByAPI: Bool = false

    @Published var errorMessage: String = ""
    @Published var limitExceeded: Bool = false
    @Published var limitMessage: String = ""
    
    let currencyService = CurrencyService()
    private let networkService = NetworkService()
    
    private var apiTask: Task<Void, Error>?
    
    init() {
        self.fromCurrency = currencyService.getDefaultFromCurrency()
        self.toCurrency = currencyService.getDefaultToCurrency()
        
        updateFromAmount(fromAmount)
    }
    
    func loadExchangeRate(fromAmount: Float) async {
        
        errorMessage = ""
        
        do {
            let rate = try await networkService.getExchangeRate(
                from: fromCurrency.code,
                to: toCurrency.code,
                amount: fromAmount
            )
            
            try Task.checkCancellation()
            
            exchangeRate = rate.rate
            isToChangeCausedByAPI = true
            toAmount = String(format: "%.2f", rate.toAmount)
            
        } catch is CancellationError {
        } catch {
            errorMessage = "Error loading exchange rate: \(error.localizedDescription)"
        }
    }
    
    func loadReverseExchangeRate(toAmount: Float) async {
        
        errorMessage = ""
        
        do {
            let swappedRate = try await networkService.getExchangeRate(
                from: toCurrency.code,
                to: fromCurrency.code,
                amount: toAmount
            )
            
            try Task.checkCancellation()
            
            isFromChangeCausedByAPI = true
            fromAmount = String(format: "%.2f", swappedRate.toAmount)
            exchangeRate = 1 / swappedRate.rate
            
        } catch is CancellationError {
        } catch {
            errorMessage = "Error loading exchange rate: \(error.localizedDescription)"
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
        
        apiTask?.cancel()
        apiTask = Task {
            await loadExchangeRate(fromAmount: Float(newAmount) ?? 0.0)
        }
    }
    
    func updateToAmount(_ newAmount: String) {
        toAmount = newAmount
        
        if newAmount.isEmpty || newAmount == "0" {
            fromAmount = "0"
            toAmount = "0"
            limitExceeded = false
            limitMessage = ""
            return
        }
        
        guard let targetToAmount = Float(newAmount) else { return }
        
        apiTask?.cancel()
        apiTask = Task {
            await loadReverseExchangeRate(toAmount: targetToAmount)
            
            if !validateLimit(fromAmount) {
                limitExceeded = true
                limitMessage = "Maximum sending amount: \(Int(fromCurrency.limit)) \(fromCurrency.code)"
            } else {
                limitExceeded = false
                limitMessage = ""
            }
        }
    }
    
    func swapCurrencies() {
        apiTask?.cancel()
        
        let tempCurrency = fromCurrency
        fromCurrency = toCurrency
        toCurrency = tempCurrency
        
        let tempAmount = fromAmount
        fromAmount = toAmount
        toAmount = tempAmount
        
        apiTask = Task {
            await loadExchangeRate(fromAmount: Float(fromAmount) ?? 0.0)
        }
    }
    
    private func validateLimit(_ amount: String) -> Bool {
        guard let amountValue = Float(amount) else { return false }
        return amountValue <= fromCurrency.limit
    }
}
