//
//  ExchangeRateDisplay.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//
import SwiftUI

struct ExchangeRateDisplay: View {
    let rate: String
    
    var body: some View {
        Text(rate)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 2)
            .background(Color.black)
            .cornerRadius(16)
    }
}

#Preview {
    ExchangeRateDisplay(rate: "1 PLN = 7.23 UAH")
        .padding()
}
