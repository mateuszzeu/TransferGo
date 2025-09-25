//
//  ConversionRequest.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//
import Foundation

struct ConversionRequest: Codable {
    let from: String
    let to: String
    let amount: Float
}
