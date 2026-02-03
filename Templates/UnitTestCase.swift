// MARK: - Unit Test Case Template
// iOSTestingTools Framework
// Created by Muhittin Camdali

import XCTest
@testable import iOSTestingTools

// MARK: - Base Test Case

/// Base class for all unit tests with common setup and utilities
open class BaseTestCase: XCTestCase {
    
    // MARK: - Properties
    
    /// Test timeout interval
    public var defaultTimeout: TimeInterval = 10.0
    
    /// Mock data provider
    public var mockProvider: MockDataProvider!
    
    /// Test logger
    public var logger: TestLogger!
    
    // MARK: - Lifecycle
    
    open override func setUp() {
        super.setUp()
        
        mockProvider = MockDataProvider()
        logger = TestLogger()
        
        continueAfterFailure = false
        
        logger.log("Starting test: \(name)")
    }
    
    open override func tearDown() {
        logger.log("Completed test: \(name)")
        
        mockProvider = nil
        logger = nil
        
        super.tearDown()
    }
    
    // MARK: - Utility Methods
    
    /// Wait for async operation
    public func wait(
        for duration: TimeInterval,
        description: String = "Async wait"
    ) {
        let expectation = expectation(description: description)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: duration + 1.0)
    }
    
    /// Assert async result
    public func assertAsync<T>(
        _ operation: @escaping () async throws -> T,
        timeout: TimeInterval? = nil,
        validation: @escaping (T) -> Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = expectation(description: "Async assertion")
        
        Task {
            do {
                let result = try await operation()
                XCTAssertTrue(
                    validation(result),
                    "Async validation failed",
                    file: file,
                    line: line
                )
            } catch {
                XCTFail("Async operation failed: \(error)", file: file, line: line)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout ?? defaultTimeout)
    }
    
    /// Assert throws specific error
    public func assertThrows<T, E: Error & Equatable>(
        _ operation: @autoclosure () throws -> T,
        error expectedError: E,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            _ = try operation()
            XCTFail("Expected error \(expectedError) but operation succeeded", file: file, line: line)
        } catch let error as E {
            XCTAssertEqual(error, expectedError, file: file, line: line)
        } catch {
            XCTFail("Expected \(E.self) but got \(type(of: error))", file: file, line: line)
        }
    }
}

// MARK: - Mock Data Provider

/// Provides mock data for testing
public final class MockDataProvider {
    
    private var mockData: [String: Any] = [:]
    
    public init() {}
    
    /// Register mock data
    public func register<T>(_ data: T, forKey key: String) {
        mockData[key] = data
    }
    
    /// Get mock data
    public func get<T>(_ type: T.Type, forKey key: String) -> T? {
        return mockData[key] as? T
    }
    
    /// Create mock JSON data
    public func createJSONData<T: Encodable>(_ value: T) throws -> Data {
        return try JSONEncoder().encode(value)
    }
    
    /// Create mock user
    public func createMockUser(
        id: String = UUID().uuidString,
        name: String = "Test User",
        email: String = "test@example.com"
    ) -> MockUser {
        return MockUser(id: id, name: name, email: email)
    }
    
    /// Create mock array
    public func createMockArray<T>(
        count: Int,
        generator: (Int) -> T
    ) -> [T] {
        return (0..<count).map(generator)
    }
}

// MARK: - Mock User

public struct MockUser: Codable, Equatable {
    public let id: String
    public let name: String
    public let email: String
}

// MARK: - Test Logger

/// Logger for test output
public final class TestLogger {
    
    public enum Level: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
    }
    
    private var logs: [(timestamp: Date, level: Level, message: String)] = []
    
    public init() {}
    
    public func log(_ message: String, level: Level = .info) {
        let entry = (Date(), level, message)
        logs.append(entry)
        print("[\(level.rawValue)] \(message)")
    }
    
    public func debug(_ message: String) {
        log(message, level: .debug)
    }
    
    public func warning(_ message: String) {
        log(message, level: .warning)
    }
    
    public func error(_ message: String) {
        log(message, level: .error)
    }
    
    public var allLogs: [(timestamp: Date, level: Level, message: String)] {
        return logs
    }
    
    public func clear() {
        logs.removeAll()
    }
}

// MARK: - XCTestCase Extensions

public extension XCTestCase {
    
    /// Create expectation with handler
    func expectation(
        description: String,
        handler: @escaping () -> Void
    ) -> XCTestExpectation {
        let expectation = expectation(description: description)
        DispatchQueue.main.async {
            handler()
            expectation.fulfill()
        }
        return expectation
    }
    
    /// Assert eventually (polling)
    func assertEventually(
        timeout: TimeInterval = 5.0,
        interval: TimeInterval = 0.1,
        condition: @escaping () -> Bool,
        message: String = "Condition not met within timeout",
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let startTime = Date()
        
        while Date().timeIntervalSince(startTime) < timeout {
            if condition() {
                return
            }
            Thread.sleep(forTimeInterval: interval)
        }
        
        XCTFail(message, file: file, line: line)
    }
    
    /// Measure performance with baseline
    func measurePerformance(
        baseline: TimeInterval,
        maxDeviation: Double = 0.2,
        block: () -> Void
    ) {
        measure {
            block()
        }
        
        // Note: Access to metrics would require additional setup
    }
}

// MARK: - Async Test Utilities

public extension XCTestCase {
    
    /// Run async test
    func runAsyncTest(
        timeout: TimeInterval = 10.0,
        test: @escaping () async throws -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = expectation(description: "Async test")
        
        Task {
            do {
                try await test()
            } catch {
                XCTFail("Async test failed: \(error)", file: file, line: line)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    /// Assert async equals
    func assertAsyncEqual<T: Equatable>(
        _ expression: @escaping () async throws -> T,
        _ expected: T,
        timeout: TimeInterval = 10.0,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        runAsyncTest(timeout: timeout, test: {
            let result = try await expression()
            XCTAssertEqual(result, expected, file: file, line: line)
        }, file: file, line: line)
    }
}

// MARK: - Example Usage

/*
 final class MyServiceTests: BaseTestCase {
     
     var sut: MyService!
     
     override func setUp() {
         super.setUp()
         sut = MyService()
     }
     
     override func tearDown() {
         sut = nil
         super.tearDown()
     }
     
     func testFetchUser() {
         // Given
         let expectedUser = mockProvider.createMockUser()
         
         // When
         runAsyncTest {
             let user = try await self.sut.fetchUser(id: expectedUser.id)
             
             // Then
             XCTAssertEqual(user.id, expectedUser.id)
         }
     }
     
     func testInvalidInput() {
         // Given
         let invalidInput = ""
         
         // Then
         assertThrows(
             try sut.validate(invalidInput),
             error: ValidationError.empty
         )
     }
 }
 */
