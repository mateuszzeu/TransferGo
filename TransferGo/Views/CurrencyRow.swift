//
//  CurrencyRow.swift
//  TransferGo
//
//  Created by MAT on 24/09/2025.
//
import SwiftUI

struct CurrencyRow: View {
    let currency: Currency
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(currency.flag)
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(currency.countryName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("\(currency.currencyName) • \(currency.code)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CurrencyRow(
        currency: Currency(
            id: UUID(),
            code: "PLN",
            countryName: "Poland",
            currencyName: "Polish zloty",
            flag: "PLN",
            limit: 20000
        ),
        onTap: { }
    )
    .padding()
}
