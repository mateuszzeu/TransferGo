//
//  SwapButton.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//
import SwiftUI

struct SwapButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image("swap_icon")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    SwapButton(action: {})
        .padding()
}
