//
//  NetworkError.swift
//  TransferGo
//
//  Created by MAT on 23/09/2025.
//
import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
