//
//  TransferGoTests.swift
//  TransferGoTests
//
//  Created by MAT on 23/09/2025.
//
import XCTest
import Combine
@testable import TransferGo

// MARK: - Mock Services for Dependency Injection
final class MockCurrencyService: CurrencyService, @unchecked Sendable {
    private let _mockDefaultFromCurrency: Currency?
    private let _mockDefaultToCurrency: Currency?
    
    var mockDefaultFromCurrency: Currency? {
        get { _mockDefaultFromCurrency }
    }
    
    var mockDefaultToCurrency: Currency? {
        get { _mockDefaultToCurrency }
    }
    
    init(mockDefaultFromCurrency: Currency? = nil, mockDefaultToCurrency: Currency? = nil) {
        self._mockDefaultFromCurrency = mockDefaultFromCurrency
        self._mockDefaultToCurrency = mockDefaultToCurrency
    }
    
    override func getDefaultFromCurrency() -> Currency {
        return mockDefaultFromCurrency ?? super.getDefaultFromCurrency()
    }
    
    override func getDefaultToCurrency() -> Currency {
        return mockDefaultToCurrency ?? super.getDefaultToCurrency()
    }
}

final class MockNetworkService: NetworkService, @unchecked Sendable {
    private let _mockExchangeRate: ExchangeRate?
    private let _shouldThrowError: Bool
    private let _errorToThrow: Error
    
    var mockExchangeRate: ExchangeRate? {
        get { _mockExchangeRate }
    }
    
    var shouldThrowError: Bool {
        get { _shouldThrowError }
    }
    
    var errorToThrow: Error {
        get { _errorToThrow }
    }
    
    init(mockExchangeRate: ExchangeRate? = nil, shouldThrowError: Bool = false, errorToThrow: Error = NetworkError.invalidURL) {
        self._mockExchangeRate = mockExchangeRate
        self._shouldThrowError = shouldThrowError
        self._errorToThrow = errorToThrow
    }
    
    override func getExchangeRate(from: String, to: String, amount: Float) async throws -> ExchangeRate {
        if shouldThrowError {
            throw errorToThrow
        }
        
        return mockExchangeRate ?? ExchangeRate(
            from: from,
            to: to,
            rate: 4.2,
            fromAmount: amount,
            toAmount: amount * 4.2
        )
    }
}

// MARK: - Testable ViewModel with Dependency Injection
@MainActor
class TestableCurrencyConverterViewModel: CurrencyConverterViewModel {
    let mockCurrencyService: MockCurrencyService
    let mockNetworkService: MockNetworkService
    
    init(currencyService: MockCurrencyService, networkService: MockNetworkService) {
        self.mockCurrencyService = currencyService
        self.mockNetworkService = networkService
        super.init()
        
        self.fromCurrency = currencyService.getDefaultFromCurrency()
        self.toCurrency = currencyService.getDefaultToCurrency()
    }
    
    override func loadExchangeRate(fromAmount: Float) async {
        errorMessage = ""
        
        do {
            let rate = try await mockNetworkService.getExchangeRate(
                from: fromCurrency.code,
                to: toCurrency.code,
                amount: fromAmount
            )
            
            try Task.checkCancellation()
            
            exchangeRate = rate.rate
            isToChangeCausedByAPI = true
            toAmount = String(format: "%.2f", rate.toAmount)
            
        } catch is CancellationError {
        } catch {
            errorMessage = "Error loading exchange rate: \(error.localizedDescription)"
        }
    }
    
    override func loadReverseExchangeRate(toAmount: Float) async {
        errorMessage = ""
        
        do {
            let swappedRate = try await mockNetworkService.getExchangeRate(
                from: toCurrency.code,
                to: fromCurrency.code,
                amount: toAmount
            )
            
            try Task.checkCancellation()
            
            isFromChangeCausedByAPI = true
            fromAmount = String(format: "%.2f", swappedRate.toAmount)
            exchangeRate = 1 / swappedRate.rate
            
        } catch is CancellationError {
        } catch {
            errorMessage = "Error loading exchange rate: \(error.localizedDescription)"
        }
    }
}

// MARK: - Test Cases
@MainActor
class CurrencyConverterViewModelTests: XCTestCase {
    
    var viewModel: TestableCurrencyConverterViewModel!
    var mockCurrencyService: MockCurrencyService!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        let testFromCurrency = Currency(
            id: UUID(),
            code: "PLN",
            countryName: "Poland",
            currencyName: "Polish zloty",
            flag: "PLN",
            limit: 20000.0
        )
        
        let testToCurrency = Currency(
            id: UUID(),
            code: "EUR",
            countryName: "Germany",
            currencyName: "Euro",
            flag: "EUR",
            limit: 5000.0
        )
        
        mockCurrencyService = MockCurrencyService(
            mockDefaultFromCurrency: testFromCurrency,
            mockDefaultToCurrency: testToCurrency
        )
        mockNetworkService = MockNetworkService()
        
        viewModel = TestableCurrencyConverterViewModel(
            currencyService: mockCurrencyService,
            networkService: mockNetworkService
        )
        
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockCurrencyService = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        // Given & When - view model is initialized in setUp
        
        // Then
        XCTAssertEqual(viewModel.fromCurrency.code, "PLN")
        XCTAssertEqual(viewModel.toCurrency.code, "EUR")
        XCTAssertEqual(viewModel.fromAmount, "300.00")
        XCTAssertFalse(viewModel.limitExceeded)
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
    }
    
    // MARK: - Amount Update Tests
    
    func testUpdateFromAmount_WithValidAmount() {
        // Given
        let testAmount = "100.50"
        let expectation = XCTestExpectation(description: "Exchange rate loaded")
        
        let mockExchangeRate = ExchangeRate(
            from: "PLN",
            to: "EUR",
            rate: 0.24,
            fromAmount: 100.50,
            toAmount: 24.12
        )
        
        mockNetworkService = MockNetworkService(mockExchangeRate: mockExchangeRate)
        viewModel = TestableCurrencyConverterViewModel(
            currencyService: mockCurrencyService,
            networkService: mockNetworkService
        )
        
        // When
        viewModel.updateFromAmount(testAmount)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(viewModel.fromAmount, testAmount)
        XCTAssertEqual(viewModel.exchangeRate, 0.24)
        XCTAssertTrue(viewModel.isToChangeCausedByAPI)
        XCTAssertFalse(viewModel.limitExceeded)
    }
    
    func testUpdateFromAmount_WithEmptyAmount() {
        // Given
        let emptyAmount = ""
        
        // When
        viewModel.updateFromAmount(emptyAmount)
        
        // Then
        XCTAssertEqual(viewModel.fromAmount, "0")
        XCTAssertEqual(viewModel.toAmount, "0")
        XCTAssertFalse(viewModel.limitExceeded)
        XCTAssertTrue(viewModel.limitMessage.isEmpty)
    }
    
    func testUpdateFromAmount_WithZeroAmount() {
        // Given
        let zeroAmount = "0"
        
        // When
        viewModel.updateFromAmount(zeroAmount)
        
        // Then
        XCTAssertEqual(viewModel.fromAmount, "0")
        XCTAssertEqual(viewModel.toAmount, "0")
        XCTAssertFalse(viewModel.limitExceeded)
    }
    
    func testUpdateFromAmount_ExceedsLimit() {
        // Given
        let excessiveAmount = "25000.00"
        
        // When
        viewModel.updateFromAmount(excessiveAmount)
        
        // Then
        XCTAssertTrue(viewModel.limitExceeded)
        XCTAssertEqual(viewModel.limitMessage, "Maximum sending amount: 20000 PLN")
    }
    
    func testUpdateToAmount_WithValidAmount() {
        // Given
        let testAmount = "50.00"
        let expectation = XCTestExpectation(description: "Reverse exchange rate loaded")
        
        let mockExchangeRate = ExchangeRate(
            from: "EUR",
            to: "PLN",
            rate: 4.2,
            fromAmount: 50.00,
            toAmount: 210.00
        )
        
        mockNetworkService = MockNetworkService(mockExchangeRate: mockExchangeRate)
        viewModel = TestableCurrencyConverterViewModel(
            currencyService: mockCurrencyService,
            networkService: mockNetworkService
        )
        
        // When
        viewModel.updateToAmount(testAmount)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(viewModel.toAmount, testAmount)
        XCTAssertTrue(viewModel.isFromChangeCausedByAPI)
        XCTAssertFalse(viewModel.limitExceeded)
    }
    
    func testUpdateToAmount_WithEmptyAmount() {
        // Given
        let emptyAmount = ""
        
        // When
        viewModel.updateToAmount(emptyAmount)
        
        // Then
        XCTAssertEqual(viewModel.fromAmount, "0")
        XCTAssertEqual(viewModel.toAmount, "0")
        XCTAssertFalse(viewModel.limitExceeded)
    }
    
    // MARK: - Currency Swap Tests
    
    func testSwapCurrencies() {
        // Given
        let originalFromCurrency = viewModel.fromCurrency
        let originalToCurrency = viewModel.toCurrency
        let originalFromAmount = viewModel.fromAmount
        let originalToAmount = viewModel.toAmount
        
        // When
        viewModel.swapCurrencies()
        
        // Then
        XCTAssertEqual(viewModel.fromCurrency, originalToCurrency)
        XCTAssertEqual(viewModel.toCurrency, originalFromCurrency)
        XCTAssertEqual(viewModel.fromAmount, originalToAmount)
        XCTAssertEqual(viewModel.toAmount, originalFromAmount)
    }
    
    // MARK: - Network Error Tests
    
    func testLoadExchangeRate_NetworkError() {
        // Given
        let testAmount = "100.00"
        let expectation = XCTestExpectation(description: "Error handled")
        
        mockNetworkService = MockNetworkService(
            shouldThrowError: true,
            errorToThrow: NetworkError.invalidResponse
        )
        viewModel = TestableCurrencyConverterViewModel(
            currencyService: mockCurrencyService,
            networkService: mockNetworkService
        )
        
        // When
        viewModel.updateFromAmount(testAmount)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertTrue(viewModel.errorMessage.contains("Error loading exchange rate"))
        XCTAssertFalse(viewModel.isToChangeCausedByAPI)
    }
    
    func testLoadReverseExchangeRate_NetworkError() {
        // Given
        let testAmount = "50.00"
        let expectation = XCTestExpectation(description: "Error handled")
        
        mockNetworkService = MockNetworkService(
            shouldThrowError: true,
            errorToThrow: NetworkError.invalidURL
        )
        viewModel = TestableCurrencyConverterViewModel(
            currencyService: mockCurrencyService,
            networkService: mockNetworkService
        )
        
        // When
        viewModel.updateToAmount(testAmount)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertTrue(viewModel.errorMessage.contains("Error loading exchange rate"))
        XCTAssertFalse(viewModel.isFromChangeCausedByAPI)
    }
    
    // MARK: - Limit Validation Tests
    
    func testValidateLimit_WithinLimit() {
        // Given
        let validAmount = "1000.00"
        
        // When
        viewModel.updateFromAmount(validAmount)
        
        // Then
        XCTAssertFalse(viewModel.limitExceeded)
        XCTAssertTrue(viewModel.limitMessage.isEmpty)
    }
    
    func testValidateLimit_AtLimit() {
        // Given
        let limitAmount = "20000.00"
        
        // When
        viewModel.updateFromAmount(limitAmount)
        
        // Then
        XCTAssertFalse(viewModel.limitExceeded)
        XCTAssertTrue(viewModel.limitMessage.isEmpty)
    }
    
    func testValidateLimit_ExceedsLimit() {
        // Given
        let excessiveAmount = "25000.00"
        
        // When
        viewModel.updateFromAmount(excessiveAmount)
        
        // Then
        XCTAssertTrue(viewModel.limitExceeded)
        XCTAssertEqual(viewModel.limitMessage, "Maximum sending amount: 20000 PLN")
    }
    
    // MARK: - Publisher Tests
    
    func testPublishedProperties() {
        // Given
        let expectation = XCTestExpectation(description: "Published values updated")
        var receivedValues: [String] = []
        
        // When
        viewModel.$fromAmount
            .sink { value in
                receivedValues.append(value)
                if receivedValues.count >= 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.updateFromAmount("500.00")
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(receivedValues.contains("500.00"))
    }
}

