//
//  CurrencyCard.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//
import SwiftUI

struct CurrencyCard: View {
    let title: String
    let currency: Currency
    @Binding var amount: String
    let amountColor: Color
    let backgroundColor: Color
    let topContentPadding: CGFloat
    let onCurrencyTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack(alignment: .top) {
                Button(action: onCurrencyTap) {
                    HStack {
                        Image(currency.flag)
                            .frame(width: 32, height: 34)
                        Text(currency.code)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()

                TextField("", text: $amount)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(amountColor)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
        }
        .padding()
        .padding(.bottom, 10)
        .padding(.top, topContentPadding)
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 20) {
        CurrencyCard(
            title: "Sending from",
            currency: Currency(
                id: UUID(),
                code: "PLN",
                countryName: "Poland",
                currencyName: "Polish zloty",
                flag: "PLN",
                limit: 20000
            ),
            amount: .constant("100.00"),
            amountColor: .blue,
            backgroundColor: .white,
            topContentPadding: 0,
            onCurrencyTap: { }
        )
    }
    .padding()
}
