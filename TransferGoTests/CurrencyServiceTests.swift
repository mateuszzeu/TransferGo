//
//  CurrencyServiceTests.swift
//  TransferGo
//
//  Created by MAT on 25/09/2025.
//
import XCTest
@testable import TransferGo

class CurrencyServiceTests: XCTestCase {
    
    var currencyService: CurrencyService!
    
    override func setUp() {
        super.setUp()
        currencyService = CurrencyService()
    }
    
    override func tearDown() {
        currencyService = nil
        super.tearDown()
    }
    
    // MARK: - Default Currency Tests
    
    func testGetDefaultFromCurrency() {
        // Given & When
        let defaultFromCurrency = currencyService.getDefaultFromCurrency()
        
        // Then
        XCTAssertEqual(defaultFromCurrency.code, "PLN")
        XCTAssertEqual(defaultFromCurrency.countryName, "Poland")
        XCTAssertEqual(defaultFromCurrency.limit, 20000.0)
    }
    
    func testGetDefaultToCurrency() {
        // Given & When
        let defaultToCurrency = currencyService.getDefaultToCurrency()
        
        // Then
        XCTAssertEqual(defaultToCurrency.code, "UAH")
        XCTAssertEqual(defaultToCurrency.countryName, "Ukraine")
        XCTAssertEqual(defaultToCurrency.limit, 50000.0)
    }
    
    func testGetDefaultAmount() {
        // Given & When
        let defaultAmount = currencyService.getDefaultAmount()
        
        // Then
        XCTAssertEqual(defaultAmount, 300.0)
    }
    
    // MARK: - Supported Currencies Tests
    
    func testSupportedCurrenciesCount() {
        // Given & When
        let currencies = currencyService.supportedCurrencies
        
        // Then
        XCTAssertEqual(currencies.count, 4)
    }
    
    func testSupportedCurrenciesCodes() {
        // Given & When
        let currencies = currencyService.supportedCurrencies
        let codes = currencies.map { $0.code }
        
        // Then
        XCTAssertTrue(codes.contains("PLN"))
        XCTAssertTrue(codes.contains("EUR"))
        XCTAssertTrue(codes.contains("GBP"))
        XCTAssertTrue(codes.contains("UAH"))
    }
    
    func testCurrencyLimits() {
        // Given
        let currencies = currencyService.supportedCurrencies
        
        // When
        let plnCurrency = currencies.first { $0.code == "PLN" }
        let eurCurrency = currencies.first { $0.code == "EUR" }
        let gbpCurrency = currencies.first { $0.code == "GBP" }
        let uahCurrency = currencies.first { $0.code == "UAH" }
        
        // Then
        XCTAssertEqual(plnCurrency?.limit, 20000.0)
        XCTAssertEqual(eurCurrency?.limit, 5000.0)
        XCTAssertEqual(gbpCurrency?.limit, 1000.0)
        XCTAssertEqual(uahCurrency?.limit, 50000.0)
    }
    
    func testCurrencyProperties() {
        // Given
        let currencies = currencyService.supportedCurrencies
        
        // When
        let plnCurrency = currencies.first { $0.code == "PLN" }
        
        // Then
        XCTAssertEqual(plnCurrency?.countryName, "Poland")
        XCTAssertEqual(plnCurrency?.currencyName, "Polish zloty")
        XCTAssertEqual(plnCurrency?.flag, "PLN")
    }
    
    func testCurrencyUniqueness() {
        // Given
        let currencies = currencyService.supportedCurrencies
        
        // When
        let codes = currencies.map { $0.code }
        let uniqueCodes = Set(codes)
        
        // Then
        XCTAssertEqual(codes.count, uniqueCodes.count)
    }
}
