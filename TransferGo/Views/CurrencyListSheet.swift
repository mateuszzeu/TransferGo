//
//  CurrencyListSheet.swift
//  TransferGo
//
//  Created by MAT on 24/09/2025.
//
import SwiftUI

struct CurrencyListSheet: View {
    @State private var searchText = ""
    
    @Environment(\.dismiss) private var dismiss
    
    let currencies: [Currency]
    let title: String
    let onCurrencySelected: (Currency) -> Void
    
    var filteredCurrencies: [Currency] {
        if searchText.isEmpty {
            return currencies
        } else {
            return currencies.filter { currency in
                currency.countryName.localizedCaseInsensitiveContains(searchText) ||
                currency.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
            
            SearchBar(text: $searchText)
                .padding(.top, 16)
            
            HStack {
                Text("All countries")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 16)
            
            List(filteredCurrencies) { currency in
                CurrencyRow(
                    currency: currency,
                    onTap: {
                        onCurrencySelected(currency)
                        dismiss()
                    }
                )
            }
            .listStyle(PlainListStyle())
        }
    }
}

#Preview {
    CurrencyListSheet(
        currencies: CurrencyService().supportedCurrencies,
        title: "Sending from",
        onCurrencySelected: { _ in },
    )
}
