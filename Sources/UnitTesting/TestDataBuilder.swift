import Foundation
import XCTest

// MARK: - Test Data Builder
public class TestDataBuilder {
    
    // MARK: - Singleton
    public static let shared = TestDataBuilder()
    
    // MARK: - Private Properties
    private var testData: [String: Any] = [:]
    private var dataGenerators: [String: DataGenerator] = [:]
    private var customBuilders: [String: CustomBuilder] = [:]
    
    // MARK: - Initialization
    private init() {
        setupDefaultGenerators()
    }
    
    // MARK: - Public Methods
    
    /// Create test user with default values
    public func createTestUser(
        id: String = UUID().uuidString,
        name: String = "Test User",
        email: String = "test@example.com",
        age: Int = 25,
        isActive: Bool = true,
        createdAt: Date = Date()
    ) -> TestUser {
        return TestUser(
            id: id,
            name: name,
            email: email,
            age: age,
            isActive: isActive,
            createdAt: createdAt
        )
    }
    
    /// Create test users with specified count
    public func createTestUsers(count: Int, prefix: String = "Test User") -> [TestUser] {
        return (0..<count).map { index in
            createTestUser(
                id: "user_\(index)",
                name: "\(prefix) \(index)",
                email: "test\(index)@example.com",
                age: 20 + (index % 50),
                isActive: index % 3 != 0
            )
        }
    }
    
    /// Create test product with default values
    public func createTestProduct(
        id: String = UUID().uuidString,
        name: String = "Test Product",
        price: Double = 99.99,
        description: String = "Test product description",
        category: String = "Electronics",
        isAvailable: Bool = true,
        createdAt: Date = Date()
    ) -> TestProduct {
        return TestProduct(
            id: id,
            name: name,
            price: price,
            description: description,
            category: category,
            isAvailable: isAvailable,
            createdAt: createdAt
        )
    }
    
    /// Create test products with specified count
    public func createTestProducts(count: Int, category: String = "Electronics") -> [TestProduct] {
        return (0..<count).map { index in
            createTestProduct(
                id: "product_\(index)",
                name: "Test Product \(index)",
                price: Double(index * 10 + 10),
                description: "Test product \(index) description",
                category: category
            )
        }
    }
    
    /// Create test order with default values
    public func createTestOrder(
        id: String = UUID().uuidString,
        userId: String = UUID().uuidString,
        products: [TestProduct] = [],
        totalAmount: Double = 0.0,
        status: OrderStatus = .pending,
        createdAt: Date = Date()
    ) -> TestOrder {
        return TestOrder(
            id: id,
            userId: userId,
            products: products,
            totalAmount: totalAmount,
            status: status,
            createdAt: createdAt
        )
    }
    
    /// Create test orders with specified count
    public func createTestOrders(count: Int, userId: String? = nil) -> [TestOrder] {
        return (0..<count).map { index in
            let products = createTestProducts(count: Int.random(in: 1...5))
            let totalAmount = products.reduce(0.0) { $0 + $1.price }
            
            return createTestOrder(
                id: "order_\(index)",
                userId: userId ?? "user_\(index)",
                products: products,
                totalAmount: totalAmount,
                status: OrderStatus.allCases.randomElement() ?? .pending
            )
        }
    }
    
    /// Create test address with default values
    public func createTestAddress(
        id: String = UUID().uuidString,
        street: String = "123 Test Street",
        city: String = "Test City",
        state: String = "Test State",
        zipCode: String = "12345",
        country: String = "Test Country"
    ) -> TestAddress {
        return TestAddress(
            id: id,
            street: street,
            city: city,
            state: state,
            zipCode: zipCode,
            country: country
        )
    }
    
    /// Create test payment with default values
    public func createTestPayment(
        id: String = UUID().uuidString,
        amount: Double = 99.99,
        currency: String = "USD",
        method: PaymentMethod = .creditCard,
        status: PaymentStatus = .pending,
        createdAt: Date = Date()
    ) -> TestPayment {
        return TestPayment(
            id: id,
            amount: amount,
            currency: currency,
            method: method,
            status: status,
            createdAt: createdAt
        )
    }
    
    /// Create random string with specified length
    public func randomString(length: Int = 10, includeSpecialChars: Bool = false) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let specialChars = "!@#$%^&*()_+-=[]{}|;:,.<>?"
        let allChars = includeSpecialChars ? letters + specialChars : letters
        
        return String((0..<length).map { _ in allChars.randomElement()! })
    }
    
    /// Create random email
    public func randomEmail(domain: String = "example.com") -> String {
        let username = randomString(length: 8)
        return "\(username)@\(domain)"
    }
    
    /// Create random phone number
    public func randomPhoneNumber() -> String {
        let areaCode = String(format: "%03d", Int.random(in: 100...999))
        let prefix = String(format: "%03d", Int.random(in: 100...999))
        let lineNumber = String(format: "%04d", Int.random(in: 1000...9999))
        return "(\(areaCode)) \(prefix)-\(lineNumber)"
    }
    
    /// Create random date within range
    public func randomDate(from: Date = Date().addingTimeInterval(-365*24*60*60), to: Date = Date()) -> Date {
        let timeInterval = Double.random(in: from.timeIntervalSince1970...to.timeIntervalSince1970)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    /// Create random UUID
    public func randomUUID() -> String {
        return UUID().uuidString
    }
    
    /// Create random integer within range
    public func randomInt(from: Int = 1, to: Int = 100) -> Int {
        return Int.random(in: from...to)
    }
    
    /// Create random double within range
    public func randomDouble(from: Double = 0.0, to: Double = 1000.0) -> Double {
        return Double.random(in: from...to)
    }
    
    /// Create random boolean
    public func randomBool() -> Bool {
        return Bool.random()
    }
    
    /// Create random array of elements
    public func randomArray<T>(_ elements: [T], count: Int? = nil) -> [T] {
        let targetCount = count ?? Int.random(in: 1...elements.count)
        return Array(elements.shuffled().prefix(targetCount))
    }
    
    /// Create test data with custom builder
    public func createTestData<T>(with builder: CustomBuilder) -> T {
        return builder.build() as! T
    }
    
    /// Register custom data generator
    public func registerGenerator<T>(for type: T.Type, generator: @escaping () -> T) {
        let typeName = String(describing: type)
        dataGenerators[typeName] = DataGenerator(generator: generator)
    }
    
    /// Register custom builder
    public func registerBuilder<T>(for type: T.Type, builder: CustomBuilder) {
        let typeName = String(describing: type)
        customBuilders[typeName] = builder
    }
    
    /// Clear all test data
    public func clearTestData() {
        testData.removeAll()
    }
    
    /// Get test data by key
    public func getTestData<T>(for key: String) -> T? {
        return testData[key] as? T
    }
    
    /// Set test data for key
    public func setTestData<T>(_ data: T, for key: String) {
        testData[key] = data
    }
    
    // MARK: - Private Methods
    
    private func setupDefaultGenerators() {
        // Register default generators
        registerGenerator(for: String.self) { [weak self] in
            self?.randomString() ?? "default"
        }
        
        registerGenerator(for: Int.self) { [weak self] in
            self?.randomInt() ?? 0
        }
        
        registerGenerator(for: Double.self) { [weak self] in
            self?.randomDouble() ?? 0.0
        }
        
        registerGenerator(for: Bool.self) { [weak self] in
            self?.randomBool() ?? false
        }
        
        registerGenerator(for: Date.self) { [weak self] in
            self?.randomDate() ?? Date()
        }
    }
}

// MARK: - Supporting Types

/// Test User Model
public struct TestUser {
    public let id: String
    public let name: String
    public let email: String
    public let age: Int
    public let isActive: Bool
    public let createdAt: Date
    
    public init(id: String, name: String, email: String, age: Int, isActive: Bool, createdAt: Date) {
        self.id = id
        self.name = name
        self.email = email
        self.age = age
        self.isActive = isActive
        self.createdAt = createdAt
    }
}

/// Test Product Model
public struct TestProduct {
    public let id: String
    public let name: String
    public let price: Double
    public let description: String
    public let category: String
    public let isAvailable: Bool
    public let createdAt: Date
    
    public init(id: String, name: String, price: Double, description: String, category: String, isAvailable: Bool, createdAt: Date) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.category = category
        self.isAvailable = isAvailable
        self.createdAt = createdAt
    }
}

/// Test Order Model
public struct TestOrder {
    public let id: String
    public let userId: String
    public let products: [TestProduct]
    public let totalAmount: Double
    public let status: OrderStatus
    public let createdAt: Date
    
    public init(id: String, userId: String, products: [TestProduct], totalAmount: Double, status: OrderStatus, createdAt: Date) {
        self.id = id
        self.userId = userId
        self.products = products
        self.totalAmount = totalAmount
        self.status = status
        self.createdAt = createdAt
    }
}

/// Test Address Model
public struct TestAddress {
    public let id: String
    public let street: String
    public let city: String
    public let state: String
    public let zipCode: String
    public let country: String
    
    public init(id: String, street: String, city: String, state: String, zipCode: String, country: String) {
        self.id = id
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
    }
}

/// Test Payment Model
public struct TestPayment {
    public let id: String
    public let amount: Double
    public let currency: String
    public let method: PaymentMethod
    public let status: PaymentStatus
    public let createdAt: Date
    
    public init(id: String, amount: Double, currency: String, method: PaymentMethod, status: PaymentStatus, createdAt: Date) {
        self.id = id
        self.amount = amount
        self.currency = currency
        self.method = method
        self.status = status
        self.createdAt = createdAt
    }
}

/// Order Status Enum
public enum OrderStatus: String, CaseIterable {
    case pending = "pending"
    case processing = "processing"
    case shipped = "shipped"
    case delivered = "delivered"
    case cancelled = "cancelled"
    case refunded = "refunded"
}

/// Payment Method Enum
public enum PaymentMethod: String, CaseIterable {
    case creditCard = "credit_card"
    case debitCard = "debit_card"
    case paypal = "paypal"
    case applePay = "apple_pay"
    case googlePay = "google_pay"
    case bankTransfer = "bank_transfer"
}

/// Payment Status Enum
public enum PaymentStatus: String, CaseIterable {
    case pending = "pending"
    case processing = "processing"
    case completed = "completed"
    case failed = "failed"
    case refunded = "refunded"
    case cancelled = "cancelled"
}

/// Data Generator
public class DataGenerator {
    private let generator: () -> Any
    
    public init(generator: @escaping () -> Any) {
        self.generator = generator
    }
    
    public func generate() -> Any {
        return generator()
    }
}

/// Custom Builder Protocol
public protocol CustomBuilder {
    func build() -> Any
}

/// Test Data Builder Error
public enum TestDataBuilderError: LocalizedError {
    case invalidDataType
    case generatorNotFound
    case builderNotFound
    case invalidConfiguration
    
    public var errorDescription: String? {
        switch self {
        case .invalidDataType:
            return "Invalid data type"
        case .generatorNotFound:
            return "Generator not found"
        case .builderNotFound:
            return "Builder not found"
        case .invalidConfiguration:
            return "Invalid configuration"
        }
    }
} 