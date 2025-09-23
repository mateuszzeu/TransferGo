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
    let name: String
    let country: String
    let flag: String
    let limit: Double
}
