//
//  ExchangeRate.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//
import Foundation

struct ExchangeRate: Codable {
    let from: String
    let to: String
    let rate: Double
    let fromAmount: Float
    let toAmount: Float
}
