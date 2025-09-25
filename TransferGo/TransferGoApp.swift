//
//  TransferGoApp.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//

import SwiftUI

@main
struct TransferGoApp: App {
    var body: some Scene {
        WindowGroup {
            CurrencyConverterView()
                .preferredColorScheme(.light)
        }
    }
}
