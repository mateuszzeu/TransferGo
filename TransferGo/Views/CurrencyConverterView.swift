//
//  CurrencyConverterView.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//

import SwiftUI

struct CurrencyConverterView: View {
    @StateObject private var viewModel = CurrencyConverterViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Currency Converter")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                Text("From: \(viewModel.fromCurrency.countryName) (\(viewModel.fromCurrency.code))")
                Text("Amount: \(viewModel.fromAmount)")
                
                if viewModel.exchangeRate > 0 {
                    Text("Rate: \(String(format: "%.4f", viewModel.exchangeRate))")
                }
                
                Text("To: \(viewModel.toCurrency.countryName) (\(viewModel.toCurrency.code))")
                Text("Result: \(viewModel.toAmount)")
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
    }
}

#Preview {
    CurrencyConverterView()
}
