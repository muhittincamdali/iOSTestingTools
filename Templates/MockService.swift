// MARK: - Mock Service Template
// iOSTestingTools Framework
// Created by Muhittin Camdali

import Foundation

// MARK: - Mock Service Protocol

/// Protocol for mock service implementations
public protocol MockServiceProtocol {
    /// Configure mock response
    func setResponse<T>(_ response: T, for identifier: String)
    
    /// Configure mock error
    func setError(_ error: Error, for identifier: String)
    
    /// Configure delay
    func setDelay(_ delay: TimeInterval, for identifier: String)
    
    /// Reset all configurations
    func reset()
    
    /// Get call count
    func callCount(for identifier: String) -> Int
}

// MARK: - Mock Configuration

/// Configuration for mock responses
public struct MockConfiguration {
    public let response: Any?
    public let error: Error?
    public let delay: TimeInterval
    
    public init(
        response: Any? = nil,
        error: Error? = nil,
        delay: TimeInterval = 0
    ) {
        self.response = response
        self.error = error
        self.delay = delay
    }
}

// MARK: - Base Mock Service

/// Base implementation for mock services
open class BaseMockService: MockServiceProtocol {
    
    // MARK: - Properties
    
    private var configurations: [String: MockConfiguration] = [:]
    private var callCounts: [String: Int] = [:]
    private var callHistory: [String: [Any]] = [:]
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Configuration
    
    public func setResponse<T>(_ response: T, for identifier: String) {
        configurations[identifier] = MockConfiguration(response: response)
    }
    
    public func setError(_ error: Error, for identifier: String) {
        configurations[identifier] = MockConfiguration(error: error)
    }
    
    public func setDelay(_ delay: TimeInterval, for identifier: String) {
        let existing = configurations[identifier]
        configurations[identifier] = MockConfiguration(
            response: existing?.response,
            error: existing?.error,
            delay: delay
        )
    }
    
    public func setConfiguration(_ config: MockConfiguration, for identifier: String) {
        configurations[identifier] = config
    }
    
    public func reset() {
        configurations.removeAll()
        callCounts.removeAll()
        callHistory.removeAll()
    }
    
    // MARK: - Call Tracking
    
    public func callCount(for identifier: String) -> Int {
        return callCounts[identifier] ?? 0
    }
    
    public func history(for identifier: String) -> [Any] {
        return callHistory[identifier] ?? []
    }
    
    public func wasCalled(_ identifier: String) -> Bool {
        return callCount(for: identifier) > 0
    }
    
    // MARK: - Execution
    
    public func recordCall(_ identifier: String, arguments: Any? = nil) {
        callCounts[identifier, default: 0] += 1
        if let args = arguments {
            callHistory[identifier, default: []].append(args)
        }
    }
    
    public func getResponse<T>(
        for identifier: String,
        defaultValue: T? = nil
    ) async throws -> T {
        recordCall(identifier)
        
        guard let config = configurations[identifier] else {
            if let defaultValue = defaultValue {
                return defaultValue
            }
            throw MockError.notConfigured(identifier)
        }
        
        // Apply delay
        if config.delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(config.delay * 1_000_000_000))
        }
        
        // Check for error
        if let error = config.error {
            throw error
        }
        
        // Return response
        guard let response = config.response as? T else {
            throw MockError.invalidResponseType(expected: String(describing: T.self))
        }
        
        return response
    }
}

// MARK: - Mock Error

public enum MockError: LocalizedError {
    case notConfigured(String)
    case invalidResponseType(expected: String)
    case simulatedError(String)
    
    public var errorDescription: String? {
        switch self {
        case .notConfigured(let identifier):
            return "Mock not configured for: \(identifier)"
        case .invalidResponseType(let expected):
            return "Invalid response type. Expected: \(expected)"
        case .simulatedError(let message):
            return "Simulated error: \(message)"
        }
    }
}

// MARK: - Mock Network Service

/// Mock implementation for network services
public final class MockNetworkService: BaseMockService {
    
    public struct Request: Equatable {
        public let url: URL
        public let method: String
        public let body: Data?
        
        public init(url: URL, method: String, body: Data? = nil) {
            self.url = url
            self.method = method
            self.body = body
        }
    }
    
    private var requestHistory: [Request] = []
    
    public override func reset() {
        super.reset()
        requestHistory.removeAll()
    }
    
    public func request<T: Decodable>(
        url: URL,
        method: String = "GET",
        body: Data? = nil
    ) async throws -> T {
        let request = Request(url: url, method: method, body: body)
        requestHistory.append(request)
        
        let identifier = "\(method):\(url.path)"
        return try await getResponse(for: identifier)
    }
    
    public var allRequests: [Request] {
        return requestHistory
    }
    
    public func requests(matching path: String) -> [Request] {
        return requestHistory.filter { $0.url.path.contains(path) }
    }
}

// MARK: - Mock Storage Service

/// Mock implementation for storage services
public final class MockStorageService: BaseMockService {
    
    private var storage: [String: Any] = [:]
    
    public override func reset() {
        super.reset()
        storage.removeAll()
    }
    
    public func save<T: Codable>(_ value: T, forKey key: String) throws {
        recordCall("save:\(key)", arguments: value)
        storage[key] = value
    }
    
    public func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T? {
        recordCall("load:\(key)")
        return storage[key] as? T
    }
    
    public func delete(forKey key: String) throws {
        recordCall("delete:\(key)")
        storage.removeValue(forKey: key)
    }
    
    public func exists(forKey key: String) -> Bool {
        recordCall("exists:\(key)")
        return storage[key] != nil
    }
    
    public var allKeys: [String] {
        return Array(storage.keys)
    }
}

// MARK: - Mock Authentication Service

/// Mock implementation for authentication services
public final class MockAuthService: BaseMockService {
    
    public struct User: Codable, Equatable {
        public let id: String
        public let email: String
        public let token: String
        
        public init(id: String, email: String, token: String) {
            self.id = id
            self.email = email
            self.token = token
        }
    }
    
    public private(set) var currentUser: User?
    public private(set) var isAuthenticated: Bool = false
    
    public override func reset() {
        super.reset()
        currentUser = nil
        isAuthenticated = false
    }
    
    public func login(email: String, password: String) async throws -> User {
        recordCall("login", arguments: ["email": email])
        
        let user: User = try await getResponse(for: "login")
        currentUser = user
        isAuthenticated = true
        return user
    }
    
    public func logout() async throws {
        recordCall("logout")
        currentUser = nil
        isAuthenticated = false
    }
    
    public func refreshToken() async throws -> String {
        recordCall("refreshToken")
        return try await getResponse(for: "refreshToken")
    }
    
    /// Simulate logged in state
    public func simulateLoggedIn(user: User) {
        currentUser = user
        isAuthenticated = true
    }
}

// MARK: - Mock Notification Service

/// Mock implementation for notification services
public final class MockNotificationService: BaseMockService {
    
    public struct Notification {
        public let title: String
        public let body: String
        public let userInfo: [String: Any]
        public let timestamp: Date
        
        public init(title: String, body: String, userInfo: [String: Any] = [:]) {
            self.title = title
            self.body = body
            self.userInfo = userInfo
            self.timestamp = Date()
        }
    }
    
    private var scheduledNotifications: [Notification] = []
    private var deliveredNotifications: [Notification] = []
    
    public override func reset() {
        super.reset()
        scheduledNotifications.removeAll()
        deliveredNotifications.removeAll()
    }
    
    public func schedule(_ notification: Notification) {
        recordCall("schedule", arguments: notification)
        scheduledNotifications.append(notification)
    }
    
    public func deliver(_ notification: Notification) {
        recordCall("deliver", arguments: notification)
        deliveredNotifications.append(notification)
    }
    
    public func cancelAll() {
        recordCall("cancelAll")
        scheduledNotifications.removeAll()
    }
    
    public var allScheduled: [Notification] {
        return scheduledNotifications
    }
    
    public var allDelivered: [Notification] {
        return deliveredNotifications
    }
}

// MARK: - Usage Example

/*
 // Create mock service
 let mockNetwork = MockNetworkService()
 
 // Configure responses
 let mockUser = User(id: "1", name: "Test")
 mockNetwork.setResponse(mockUser, for: "GET:/users/1")
 mockNetwork.setDelay(0.5, for: "GET:/users/1")
 
 // Use in tests
 let user: User = try await mockNetwork.request(
     url: URL(string: "https://api.example.com/users/1")!
 )
 
 // Verify calls
 XCTAssertTrue(mockNetwork.wasCalled("GET:/users/1"))
 XCTAssertEqual(mockNetwork.callCount(for: "GET:/users/1"), 1)
 */
