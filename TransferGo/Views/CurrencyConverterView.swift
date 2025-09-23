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
                topContentPadding: 0
            )
            .padding(.horizontal)
            .zIndex(1)
            
            CurrencyCard(
                title: "Receiver gets",
                currency: viewModel.toCurrency,
                amount: viewModel.toAmount,
                amountColor: .black,
                backgroundColor: Color(red: 0.94, green: 0.94, blue: 0.94),
                topContentPadding: 30
            )
            .padding(.horizontal)
            .padding(.top, 85)
            .zIndex(0)
            
            Text("1 PLN = 7.23 UAH")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 2)
                .background(Color.black)
                .cornerRadius(16)
                .offset(y: 105)
                .zIndex(2)
        }
    }
}

#Preview {
    CurrencyConverterView()
}
