//
//  Currency.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//
import Foundation

struct Currency: Identifiable, Codable, Equatable {
    let id: UUID
    let code: String
    let countryName: String
    let currencyName: String
    let flag: String
    let limit: Double
}
