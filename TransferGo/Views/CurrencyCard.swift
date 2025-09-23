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
    let amount: String
    let amountColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack {
                HStack {
                    Image(currency.flag)
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text(currency.code)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(amount)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(amountColor)
            }
        }
        .padding()
        .background(Color.white)
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
            amount: "100.00",
            amountColor: .blue
        )
        
        CurrencyCard(
            title: "Receiver gets",
            currency: Currency(
                id: UUID(),
                code: "UAH",
                countryName: "Ukraine",
                currencyName: "Hrivna",
                flag: "UAH",
                limit: 50000
            ),
            amount: "723.38",
            amountColor: .black
        )
    }
    .padding()
}
