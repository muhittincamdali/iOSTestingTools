import Foundation
import XCTest

// MARK: - Test Utilities
public class TestUtilities {
    
    // MARK: - Singleton
    public static let shared = TestUtilities()
    
    // MARK: - Private Properties
    private var utilities: [String: Any] = [:]
    
    // MARK: - Initialization
    private init() {
        setupDefaultUtilities()
    }
    
    // MARK: - Public Methods
    
    /// Initialize test utilities
    public static func initialize() {
        shared.setupEnvironment()
    }
    
    /// Set up test utilities environment
    public func setupEnvironment() {
        print("✅ TestUtilities initialized successfully")
    }
    
    /// Generate random string
    public func randomString(length: Int = 10) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    /// Generate random email
    public func randomEmail(domain: String = "example.com") -> String {
        let username = randomString(length: 8)
        return "\(username)@\(domain)"
    }
    
    /// Generate random phone number
    public func randomPhoneNumber() -> String {
        let areaCode = String(format: "%03d", Int.random(in: 100...999))
        let prefix = String(format: "%03d", Int.random(in: 100...999))
        let lineNumber = String(format: "%04d", Int.random(in: 1000...9999))
        return "(\(areaCode)) \(prefix)-\(lineNumber)"
    }
    
    /// Generate random date
    public func randomDate(from: Date = Date().addingTimeInterval(-365*24*60*60), to: Date = Date()) -> Date {
        let timeInterval = Double.random(in: from.timeIntervalSince1970...to.timeIntervalSince1970)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    /// Generate random UUID
    public func randomUUID() -> String {
        return UUID().uuidString
    }
    
    /// Generate random integer
    public func randomInt(from: Int = 1, to: Int = 100) -> Int {
        return Int.random(in: from...to)
    }
    
    /// Generate random double
    public func randomDouble(from: Double = 0.0, to: Double = 1000.0) -> Double {
        return Double.random(in: from...to)
    }
    
    /// Generate random boolean
    public func randomBool() -> Bool {
        return Bool.random()
    }
    
    /// Wait for a specific time
    public func wait(for seconds: TimeInterval) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
    
    /// Retry operation with exponential backoff
    public func retry<T>(operation: @escaping () async throws -> T, maxAttempts: Int = 3, initialDelay: TimeInterval = 1.0) async throws -> T {
        var lastError: Error?
        var delay = initialDelay
        
        for attempt in 1...maxAttempts {
            do {
                return try await operation()
            } catch {
                lastError = error
                
                if attempt < maxAttempts {
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    delay *= 2 // Exponential backoff
                }
            }
        }
        
        throw lastError ?? TestUtilitiesError.retryFailed
    }
    
    /// Measure execution time
    public func measureExecutionTime<T>(operation: () throws -> T) throws -> (result: T, duration: TimeInterval) {
        let startTime = Date()
        let result = try operation()
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        return (result, duration)
    }
    
    /// Measure async execution time
    public func measureAsyncExecutionTime<T>(operation: @escaping () async throws -> T) async throws -> (result: T, duration: TimeInterval) {
        let startTime = Date()
        let result = try await operation()
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        return (result, duration)
    }
    
    /// Create temporary file
    public func createTemporaryFile(name: String, content: String) throws -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(name)
        
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        
        return fileURL
    }
    
    /// Delete temporary file
    public func deleteTemporaryFile(at url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }
    
    /// Validate email format
    public func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Validate phone number format
    public func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^\\+?[1-9]\\d{1,14}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    /// Validate URL format
    public func isValidURL(_ url: String) -> Bool {
        guard let url = URL(string: url) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    // MARK: - Private Methods
    
    private func setupDefaultUtilities() {
        // Setup default utilities
        utilities["randomString"] = randomString
        utilities["randomEmail"] = randomEmail
        utilities["randomPhoneNumber"] = randomPhoneNumber
        utilities["randomDate"] = randomDate
        utilities["randomUUID"] = randomUUID
        utilities["randomInt"] = randomInt
        utilities["randomDouble"] = randomDouble
        utilities["randomBool"] = randomBool
    }
}

// MARK: - Supporting Types

/// Test Utilities Error
public enum TestUtilitiesError: LocalizedError {
    case fileNotFound(String)
    case invalidData(String)
    case retryFailed
    case timeout(String)
    
    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let file):
            return "File not found: \(file)"
        case .invalidData(let message):
            return "Invalid data: \(message)"
        case .retryFailed:
            return "Retry operation failed"
        case .timeout(let message):
            return "Timeout: \(message)"
        }
    }
} 