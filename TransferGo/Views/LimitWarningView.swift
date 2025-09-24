//
//  LimitWarningView.swift
//  TransferGo
//
//  Created by MAT on 24/09/2025.
//

import SwiftUI

struct LimitWarningView: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "info.circle")
                .foregroundColor(.red.opacity(0.6))
                .font(.caption)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.red.opacity(0.6))
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.red.opacity(0.06))
        .cornerRadius(8)
    }
}

#Preview {
    LimitWarningView(message: "Maximum sending amount: 20000 PLN")
        .padding()
}
