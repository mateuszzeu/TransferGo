//
//  SearchBar.swift
//  TransferGo
//
//  Created by MAT on 24/09/2025.
//
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Search")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal, 4)
                .background(Color.white)
                .offset(x: 10, y: 7)
                .zIndex(1)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
                
                TextField("", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 8)
            }
            .padding(.horizontal, 8)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}

#Preview {
    SearchBar(text: .constant(""))
        .padding()
}
