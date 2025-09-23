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
        ZStack(alignment: .top) {
            CurrencyCard(
                title: "Sending from",
                currency: viewModel.fromCurrency,
                amount: viewModel.fromAmount,
                amountColor: .blue,
                backgroundColor: .white,
                topContentPadding: 0,
                isEditable: true,
                onAmountChange: { newAmount in 
                    viewModel.updateFromAmount(newAmount)
                }
            )
            .padding(.horizontal)
            .zIndex(1)
            
            CurrencyCard(
                title: "Receiver gets",
                currency: viewModel.toCurrency,
                amount: viewModel.toAmount,
                amountColor: .black,
                backgroundColor: Color(red: 0.94, green: 0.94, blue: 0.94),
                topContentPadding: 30,
                isEditable: true,
                onAmountChange: { newAmount in
                    viewModel.updateToAmount(newAmount)
                }
            )
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
        }
    }
}

#Preview {
    CurrencyConverterView()
}
