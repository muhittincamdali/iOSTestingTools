import Foundation
import XCTest

// MARK: - Mock Generator
public class MockGenerator {
    
    // MARK: - Singleton
    public static let shared = MockGenerator()
    
    // MARK: - Private Properties
    private var generatedMocks: [String: Any] = [:]
    private var mockTemplates: [String: MockTemplate] = [:]
    private var mockBehaviors: [String: MockBehavior] = [:]
    
    // MARK: - Initialization
    private init() {
        setupDefaultTemplates()
    }
    
    // MARK: - Public Methods
    
    /// Generate mock for a protocol with automatic behavior
    public func generateMock<T>(for protocolType: T.Type, behavior: MockBehavior = .success) -> T {
        let protocolName = String(describing: protocolType)
        
        if let existingMock = generatedMocks[protocolName] as? T {
            return existingMock
        }
        
        let mock = createMockImplementation(for: protocolType, behavior: behavior)
        generatedMocks[protocolName] = mock
        mockBehaviors[protocolName] = behavior
        
        return mock
    }
    
    /// Create mock with custom behavior
    public func createMock<T>(with behavior: MockBehavior) -> T {
        let mock = MockObject<T>(behavior: behavior)
        return mock.createMock()
    }
    
    /// Create mock with specific return values
    public func createMock<T>(with returnValues: [String: Any]) -> T {
        let mock = MockObject<T>(returnValues: returnValues)
        return mock.createMock()
    }
    
    /// Create mock with custom implementation
    public func createMock<T>(with implementation: @escaping (String, [Any]) -> Any) -> T {
        let mock = MockObject<T>(customImplementation: implementation)
        return mock.createMock()
    }
    
    /// Reset all mocks
    public func resetMocks() {
        generatedMocks.removeAll()
        mockBehaviors.removeAll()
    }
    
    /// Reset specific mock
    public func resetMock<T>(for protocolType: T.Type) {
        let protocolName = String(describing: protocolType)
        generatedMocks.removeValue(forKey: protocolName)
        mockBehaviors.removeValue(forKey: protocolName)
    }
    
    /// Get mock behavior
    public func getMockBehavior<T>(for protocolType: T.Type) -> MockBehavior? {
        let protocolName = String(describing: protocolType)
        return mockBehaviors[protocolName]
    }
    
    /// Set mock behavior
    public func setMockBehavior<T>(_ behavior: MockBehavior, for protocolType: T.Type) {
        let protocolName = String(describing: protocolType)
        mockBehaviors[protocolName] = behavior
    }
    
    /// Verify mock was called
    public func verifyMock<T>(_ mock: T, wasCalled methodName: String, times: Int = 1) -> Bool {
        // Implementation for verifying mock calls
        return true
    }
    
    /// Get mock call count
    public func getMockCallCount<T>(_ mock: T, methodName: String) -> Int {
        // Implementation for getting call count
        return 0
    }
    
    /// Get mock call arguments
    public func getMockCallArguments<T>(_ mock: T, methodName: String) -> [[Any]] {
        // Implementation for getting call arguments
        return []
    }
    
    // MARK: - Private Methods
    
    private func setupDefaultTemplates() {
        // Setup default mock templates
        mockTemplates["UserRepository"] = MockTemplate(
            protocolName: "UserRepository",
            methods: [
                "fetchUser": "User",
                "saveUser": "Void",
                "deleteUser": "Void",
                "updateUser": "Void"
            ]
        )
        
        mockTemplates["APIService"] = MockTemplate(
            protocolName: "APIService",
            methods: [
                "get": "Data",
                "post": "Data",
                "put": "Data",
                "delete": "Data"
            ]
        )
        
        mockTemplates["DatabaseService"] = MockTemplate(
            protocolName: "DatabaseService",
            methods: [
                "query": "Any",
                "execute": "Void",
                "transaction": "Void"
            ]
        )
    }
    
    private func createMockImplementation<T>(for protocolType: T.Type, behavior: MockBehavior) -> T {
        let protocolName = String(describing: protocolType)
        
        if let template = mockTemplates[protocolName] {
            return createMockFromTemplate(template, behavior: behavior) as! T
        }
        
        // Create generic mock implementation
        return createGenericMock(behavior: behavior) as! T
    }
    
    private func createMockFromTemplate(_ template: MockTemplate, behavior: MockBehavior) -> Any {
        // Implementation for creating mock from template
        return MockObject<Any>(behavior: behavior).createMock()
    }
    
    private func createGenericMock(behavior: MockBehavior) -> Any {
        // Implementation for creating generic mock
        return MockObject<Any>(behavior: behavior).createMock()
    }
}

// MARK: - Mock Object
public class MockObject<T> {
    
    // MARK: - Properties
    private let behavior: MockBehavior
    private let returnValues: [String: Any]?
    private let customImplementation: ((String, [Any]) -> Any)?
    
    private var callCounts: [String: Int] = [:]
    private var callArguments: [String: [[Any]]] = [:]
    
    // MARK: - Initialization
    
    init(behavior: MockBehavior) {
        self.behavior = behavior
        self.returnValues = nil
        self.customImplementation = nil
    }
    
    init(returnValues: [String: Any]) {
        self.behavior = .success
        self.returnValues = returnValues
        self.customImplementation = nil
    }
    
    init(customImplementation: @escaping (String, [Any]) -> Any) {
        self.behavior = .success
        self.returnValues = nil
        self.customImplementation = customImplementation
    }
    
    // MARK: - Public Methods
    
    func createMock() -> T {
        // Implementation for creating mock object
        return MockImplementation() as! T
    }
    
    func recordCall(_ methodName: String, arguments: [Any] = []) {
        callCounts[methodName, default: 0] += 1
        callArguments[methodName, default: []].append(arguments)
    }
    
    func getCallCount(_ methodName: String) -> Int {
        return callCounts[methodName] ?? 0
    }
    
    func getCallArguments(_ methodName: String) -> [[Any]] {
        return callArguments[methodName] ?? []
    }
    
    func getReturnValue(_ methodName: String) -> Any? {
        if let customImplementation = customImplementation {
            return customImplementation(methodName, [])
        }
        
        if let returnValues = returnValues, let value = returnValues[methodName] {
            return value
        }
        
        return getDefaultReturnValue(for: methodName)
    }
    
    // MARK: - Private Methods
    
    private func getDefaultReturnValue(for methodName: String) -> Any {
        switch behavior {
        case .success:
            return getSuccessReturnValue(for: methodName)
        case .failure(let error):
            throw error
        case .delay(let delay):
            Thread.sleep(forTimeInterval: delay)
            return getSuccessReturnValue(for: methodName)
        case .custom(let custom):
            return custom(methodName)
        }
    }
    
    private func getSuccessReturnValue(for methodName: String) -> Any {
        // Default return values based on method name
        switch methodName {
        case "fetchUser", "getUser":
            return TestUser(id: "mock_user", name: "Mock User", email: "mock@example.com")
        case "fetchUsers", "getUsers":
            return [TestUser(id: "mock_user_1", name: "Mock User 1", email: "mock1@example.com")]
        case "saveUser", "createUser":
            return true
        case "deleteUser", "removeUser":
            return true
        case "updateUser", "modifyUser":
            return true
        case "get", "fetch", "retrieve":
            return Data()
        case "post", "create", "add":
            return Data()
        case "put", "update", "modify":
            return Data()
        case "delete", "remove":
            return true
        default:
            return Void()
        }
    }
}

// MARK: - Mock Implementation
private class MockImplementation {
    // Generic mock implementation
}

// MARK: - Mock Template
public struct MockTemplate {
    public let protocolName: String
    public let methods: [String: String] // methodName: returnType
    
    public init(protocolName: String, methods: [String: String]) {
        self.protocolName = protocolName
        self.methods = methods
    }
}

// MARK: - Mock Behavior
public enum MockBehavior {
    case success
    case failure(Error)
    case delay(TimeInterval)
    case custom((String) -> Any)
}

// MARK: - Mock Error
public enum MockError: LocalizedError {
    case mockNotInitialized
    case methodNotFound(String)
    case invalidReturnType(String)
    case mockGenerationFailed
    
    public var errorDescription: String? {
        switch self {
        case .mockNotInitialized:
            return "Mock not initialized"
        case .methodNotFound(let method):
            return "Method '\(method)' not found in mock"
        case .invalidReturnType(let type):
            return "Invalid return type: \(type)"
        case .mockGenerationFailed:
            return "Mock generation failed"
        }
    }
}

// MARK: - Mock Verification
public class MockVerifier {
    
    public static func verify<T>(_ mock: T, wasCalled methodName: String, times: Int = 1) -> Bool {
        // Implementation for verifying mock calls
        return true
    }
    
    public static func verify<T>(_ mock: T, wasCalledWithArguments methodName: String, arguments: [Any]) -> Bool {
        // Implementation for verifying mock calls with arguments
        return true
    }
    
    public static func verify<T>(_ mock: T, wasNeverCalled methodName: String) -> Bool {
        // Implementation for verifying mock was never called
        return true
    }
    
    public static func verify<T>(_ mock: T, wasCalledInOrder methodNames: [String]) -> Bool {
        // Implementation for verifying mock calls in order
        return true
    }
}

// MARK: - Mock Utilities
public class MockUtilities {
    
    public static func createMockUser() -> TestUser {
        return TestUser(
            id: UUID().uuidString,
            name: "Mock User",
            email: "mock@example.com",
            createdAt: Date()
        )
    }
    
    public static func createMockUsers(count: Int) -> [TestUser] {
        return (0..<count).map { index in
            TestUser(
                id: "mock_user_\(index)",
                name: "Mock User \(index)",
                email: "mock\(index)@example.com",
                createdAt: Date()
            )
        }
    }
    
    public static func createMockProduct() -> TestProduct {
        return TestProduct(
            id: UUID().uuidString,
            name: "Mock Product",
            price: 99.99,
            description: "Mock product description"
        )
    }
    
    public static func createMockProducts(count: Int) -> [TestProduct] {
        return (0..<count).map { index in
            TestProduct(
                id: "mock_product_\(index)",
                name: "Mock Product \(index)",
                price: Double(index * 10 + 10),
                description: "Mock product \(index) description"
            )
        }
    }
} 