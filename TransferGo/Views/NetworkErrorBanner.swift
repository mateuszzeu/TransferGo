//
//  NetworkErrorBanner.swift
//  TransferGo
//
//  Created by MAT on 24/09/2025.
//

import SwiftUI

struct NetworkErrorBanner: View {
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.7))
                    .frame(width: 32, height: 32)
                
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("No network")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Check your internet connection")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.top, -20)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack {
        NetworkErrorBanner(onDismiss: {})
        Spacer()
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
