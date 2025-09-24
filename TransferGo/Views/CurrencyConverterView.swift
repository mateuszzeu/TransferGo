//
//  CurrencyConverterView.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//

import SwiftUI

struct CurrencyConverterView: View {
    @StateObject private var viewModel = CurrencyConverterViewModel()
    
    @State private var showingCurrencySheet = false
    @State private var isSelectingFromCurrency = true
    
    var body: some View {
        ZStack(alignment: .top) {
            CurrencyCard(
                title: "Sending from",
                currency: viewModel.fromCurrency,
                amount: $viewModel.fromAmount,
                amountColor: .blue,
                backgroundColor: .white,
                topContentPadding: 0,
                onCurrencyTap: {
                    isSelectingFromCurrency = true
                    showingCurrencySheet = true
                }
            )
            .onChange(of: viewModel.fromAmount) { _, newValue in
                viewModel.updateFromAmount(newValue)
            }
            .padding(.horizontal)
            .zIndex(1)
            
            CurrencyCard(
                title: "Receiver gets",
                currency: viewModel.toCurrency,
                amount: $viewModel.toAmount,
                amountColor: .black,
                backgroundColor: Color(red: 0.94, green: 0.94, blue: 0.94),
                topContentPadding: 30,
                onCurrencyTap: {
                    isSelectingFromCurrency = false
                    showingCurrencySheet = true
                }
            )
            .padding(.horizontal)
            .padding(.top, 85)
            .zIndex(0)
            .onChange(of: viewModel.toAmount) { _, newValue in
                viewModel.updateToAmount(newValue)
            }
            
            ExchangeRateDisplay(rate: "1 \(viewModel.fromCurrency.code) = \(String(format: "%.4f", viewModel.exchangeRate)) \(viewModel.toCurrency.code)")
                .offset(y: 105)
                .zIndex(2)
            
            SwapButton(action: {
                viewModel.swapCurrencies()
            })
            .offset(x: -130, y: 100)
            .zIndex(2)
            
            if viewModel.limitExceeded {
                LimitWarningView(message: viewModel.limitMessage)
                    .padding(.horizontal)
                    .offset(y: 250)
                    .zIndex(3)
            }
        }
        .sheet(isPresented: $showingCurrencySheet) {
            CurrencyListSheet(
                currencies: viewModel.currencyService.supportedCurrencies,
                title: isSelectingFromCurrency ? "Sending from" : "Sending to",
                onCurrencySelected: { currency in
                    if isSelectingFromCurrency {
                        viewModel.fromCurrency = currency
                    } else {
                        viewModel.toCurrency = currency
                    }
                    Task { await viewModel.loadExchangeRate() }
                }
            )
        }
    }
}

#Preview {
    CurrencyConverterView()
}
