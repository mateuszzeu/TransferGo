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
    @State private var isEditingFrom = false
    @State private var isEditingTo = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            CurrencyCard(
                title: "Sending from",
                currency: viewModel.fromCurrency,
                amount: Binding(
                    get: { viewModel.fromAmount },
                    set: { newValue in
                        viewModel.fromAmount = newValue
                        isEditingFrom = true
                    }
                ),
                amountColor: .blue,
                backgroundColor: .white,
                topContentPadding: 0,
                onCurrencyTap: {
                    isSelectingFromCurrency = true
                    showingCurrencySheet = true
                }
            )
            .onChange(of: viewModel.fromAmount) { _, newValue in
                if viewModel.isFromChangeCausedByAPI {
                    viewModel.isFromChangeCausedByAPI = false
                    return
                }
                if isEditingFrom {
                    viewModel.updateFromAmount(newValue)
                    isEditingFrom = false
                }
            }
            .padding(.horizontal)
            .zIndex(1)
            
            CurrencyCard(
                title: "Receiver gets",
                currency: viewModel.toCurrency,
                amount: Binding(
                    get: { viewModel.toAmount },
                    set: { newValue in
                        viewModel.toAmount = newValue
                        isEditingTo = true
                    }
                ),
                amountColor: .black,
                backgroundColor: Color(red: 0.94, green: 0.94, blue: 0.94),
                topContentPadding: 30,
                onCurrencyTap: {
                    isSelectingFromCurrency = false
                    showingCurrencySheet = true
                }
            )
            .onChange(of: viewModel.toAmount) { _, newValue in
                if viewModel.isToChangeCausedByAPI {
                    viewModel.isToChangeCausedByAPI = false
                    return
                }
                if isEditingTo {
                    viewModel.updateToAmount(newValue)
                    isEditingTo = false
                }
            }
            .padding(.horizontal)
            .padding(.top, 85)
            .zIndex(0)
            
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
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
                    .offset(y: 280)
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
                    viewModel.updateFromAmount(viewModel.fromAmount)
                }
            )
        }
    }
}

#Preview {
    CurrencyConverterView()
}
