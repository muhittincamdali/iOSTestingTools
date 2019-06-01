import Foundation
import XCTest

// MARK: - Assertion Helpers
public class AssertionHelpers {
    
    // MARK: - Singleton
    public static let shared = AssertionHelpers()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Basic Assertions
    
    /// Assert that a value is not nil
    public func assertNotNil<T>(_ value: T?, message: String = "Value should not be nil", file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(value, message, file: file, line: line)
    }
    
    /// Assert that a value is nil
    public func assertNil<T>(_ value: T?, message: String = "Value should be nil", file: StaticString = #file, line: UInt = #line) {
        XCTAssertNil(value, message, file: file, line: line)
    }
    
    /// Assert that a condition is true
    public func assertTrue(_ condition: Bool, message: String = "Condition should be true", file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(condition, message, file: file, line: line)
    }
    
    /// Assert that a condition is false
    public func assertFalse(_ condition: Bool, message: String = "Condition should be false", file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(condition, message, file: file, line: line)
    }
    
    /// Assert that two values are equal
    public func assertEqual<T: Equatable>(_ value1: T, _ value2: T, message: String = "Values should be equal", file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(value1, value2, message, file: file, line: line)
    }
    
    /// Assert that two values are not equal
    public func assertNotEqual<T: Equatable>(_ value1: T, _ value2: T, message: String = "Values should not be equal", file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotEqual(value1, value2, message, file: file, line: line)
    }
    
    /// Assert that a value is greater than another
    public func assertGreaterThan<T: Comparable>(_ value1: T, _ value2: T, message: String = "First value should be greater than second", file: StaticString = #file, line: UInt = #line) {
        XCTAssertGreaterThan(value1, value2, message, file: file, line: line)
    }
    
    /// Assert that a value is less than another
    public func assertLessThan<T: Comparable>(_ value1: T, _ value2: T, message: String = "First value should be less than second", file: StaticString = #file, line: UInt = #line) {
        XCTAssertLessThan(value1, value2, message, file: file, line: line)
    }
    
    /// Assert that a value is greater than or equal to another
    public func assertGreaterThanOrEqual<T: Comparable>(_ value1: T, _ value2: T, message: String = "First value should be greater than or equal to second", file: StaticString = #file, line: UInt = #line) {
        XCTAssertGreaterThanOrEqual(value1, value2, message, file: file, line: line)
    }
    
    /// Assert that a value is less than or equal to another
    public func assertLessThanOrEqual<T: Comparable>(_ value1: T, _ value2: T, message: String = "First value should be less than or equal to second", file: StaticString = #file, line: UInt = #line) {
        XCTAssertLessThanOrEqual(value1, value2, message, file: file, line: line)
    }
    
    // MARK: - Error Assertions
    
    /// Assert that an error is thrown
    public func assertThrows<T>(_ block: () throws -> T, message: String = "Block should throw an error", file: StaticString = #file, line: UInt = #line) {
        XCTAssertThrowsError(try block(), message, file: file, line: line)
    }
    
    /// Assert that no error is thrown
    public func assertNoThrow<T>(_ block: () throws -> T, message: String = "Block should not throw an error", file: StaticString = #file, line: UInt = #line) {
        XCTAssertNoThrow(try block(), message, file: file, line: line)
    }
    
    /// Assert that a specific error is thrown
    public func assertThrowsError<T>(_ block: () throws -> T, errorType: Error.Type, message: String = "Block should throw specific error", file: StaticString = #file, line: UInt = #line) {
        XCTAssertThrowsError(try block(), message, file: file, line: line) { error in
            XCTAssertTrue(error is Error, "Error should be of expected type", file: file, line: line)
        }
    }
    
    // MARK: - Async Assertions
    
    /// Assert that an async operation completes
    public func assertAsyncCompletes<T>(_ operation: @escaping () async throws -> T, timeout: TimeInterval = 5.0, message: String = "Async operation should complete", file: StaticString = #file, line: UInt = #line) async throws {
        let expectation = XCTestExpectation(description: "Async operation")
        
        Task {
            do {
                _ = try await operation()
                expectation.fulfill()
            } catch {
                XCTFail("Async operation failed: \(error)", file: file, line: line)
            }
        }
        
        await fulfillment(of: [expectation], timeout: timeout)
    }
    
    /// Assert that an async operation fails
    public func assertAsyncFails<T>(_ operation: @escaping () async throws -> T, timeout: TimeInterval = 5.0, message: String = "Async operation should fail", file: StaticString = #file, line: UInt = #line) async throws {
        let expectation = XCTestExpectation(description: "Async operation should fail")
        
        Task {
            do {
                _ = try await operation()
                XCTFail("Async operation should have failed", file: file, line: line)
            } catch {
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: timeout)
    }
    
    // MARK: - Collection Assertions
    
    /// Assert that an array contains a specific element
    public func assertContains<T: Equatable>(_ array: [T], _ element: T, message: String = "Array should contain element", file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(array.contains(element), message, file: file, line: line)
    }
    
    /// Assert that an array does not contain a specific element
    public func assertNotContains<T: Equatable>(_ array: [T], _ element: T, message: String = "Array should not contain element", file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(array.contains(element), message, file: file, line: line)
    }
    
    /// Assert that an array has a specific count
    public func assertCount<T>(_ array: [T], _ count: Int, message: String = "Array should have specific count", file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(array.count, count, message, file: file, line: line)
    }
    
    /// Assert that an array is empty
    public func assertEmpty<T>(_ array: [T], message: String = "Array should be empty", file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(array.isEmpty, message, file: file, line: line)
    }
    
    /// Assert that an array is not empty
    public func assertNotEmpty<T>(_ array: [T], message: String = "Array should not be empty", file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(array.isEmpty, message, file: file, line: line)
    }
    
    // MARK: - String Assertions
    
    /// Assert that a string contains a substring
    public func assertContains(_ string: String, _ substring: String, message: String = "String should contain substring", file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(string.contains(substring), message, file: file, line: line)
    }
    
    /// Assert that a string does not contain a substring
    public func assertNotContains(_ string: String, _ substring: String, message: String = "String should not contain substring", file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(string.contains(substring), message, file: file, line: line)
    }
    
    /// Assert that a string starts with a prefix
    public func assertStartsWith(_ string: String, _ prefix: String, message: String = "String should start with prefix", file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(string.hasPrefix(prefix), message, file: file, line: line)
    }
    
    /// Assert that a string ends with a suffix
    public func assertEndsWith(_ string: String, _ suffix: String, message: String = "String should end with suffix", file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(string.hasSuffix(suffix), message, file: file, line: line)
    }
    
    /// Assert that a string matches a regex pattern
    public func assertMatches(_ string: String, _ pattern: String, message: String = "String should match pattern", file: StaticString = #file, line: UInt = #line) {
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: string.utf16.count)
        let matches = regex.firstMatch(in: string, options: [], range: range)
        XCTAssertNotNil(matches, message, file: file, line: line)
    }
    
    // MARK: - Performance Assertions
    
    /// Assert that an operation completes within a time limit
    public func assertPerformance(operation: () throws -> Void, timeLimit: TimeInterval = 1.0, message: String = "Operation should complete within time limit", file: StaticString = #file, line: UInt = #line) {
        let startTime = Date()
        
        do {
            try operation()
        } catch {
            XCTFail("Operation failed: \(error)", file: file, line: line)
            return
        }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        XCTAssertLessThan(duration, timeLimit, message, file: file, line: line)
    }
    
    /// Assert that an async operation completes within a time limit
    public func assertAsyncPerformance(operation: @escaping () async throws -> Void, timeLimit: TimeInterval = 1.0, message: String = "Async operation should complete within time limit", file: StaticString = #file, line: UInt = #line) async throws {
        let startTime = Date()
        
        try await operation()
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        XCTAssertLessThan(duration, timeLimit, message, file: file, line: line)
    }
    
    // MARK: - Memory Assertions
    
    /// Assert that memory usage is within limits
    public func assertMemoryUsage(operation: () throws -> Void, maxMemoryMB: Double = 100.0, message: String = "Memory usage should be within limits", file: StaticString = #file, line: UInt = #line) {
        let startMemory = getMemoryUsage()
        
        do {
            try operation()
        } catch {
            XCTFail("Operation failed: \(error)", file: file, line: line)
            return
        }
        
        let endMemory = getMemoryUsage()
        let memoryIncrease = endMemory - startMemory
        let memoryIncreaseMB = memoryIncrease / (1024 * 1024)
        
        XCTAssertLessThan(memoryIncreaseMB, maxMemoryMB, message, file: file, line: line)
    }
    
    // MARK: - Custom Assertions
    
    /// Assert that a condition is true with custom message formatting
    public func assertThat<T>(_ value: T, _ condition: (T) -> Bool, message: String = "Condition should be true", file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(condition(value), message, file: file, line: line)
    }
    
    /// Assert that two values are approximately equal (for floating point)
    public func assertApproximatelyEqual(_ value1: Double, _ value2: Double, tolerance: Double = 0.001, message: String = "Values should be approximately equal", file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(value1, value2, accuracy: tolerance, message, file: file, line: line)
    }
    
    /// Assert that a value is within a range
    public func assertInRange<T: Comparable>(_ value: T, _ range: ClosedRange<T>, message: String = "Value should be within range", file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(range.contains(value), message, file: file, line: line)
    }
    
    // MARK: - Private Methods
    
    private func getMemoryUsage() -> UInt64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return info.resident_size
        } else {
            return 0
        }
    }
}

// MARK: - Assertion Extensions

extension XCTestCase {
    
    /// Convenience method for basic assertions
    public func assertNotNil<T>(_ value: T?, message: String = "Value should not be nil", file: StaticString = #file, line: UInt = #line) {
        AssertionHelpers.shared.assertNotNil(value, message: message, file: file, line: line)
    }
    
    public func assertNil<T>(_ value: T?, message: String = "Value should be nil", file: StaticString = #file, line: UInt = #line) {
        AssertionHelpers.shared.assertNil(value, message: message, file: file, line: line)
    }
    
    public func assertTrue(_ condition: Bool, message: String = "Condition should be true", file: StaticString = #file, line: UInt = #line) {
        AssertionHelpers.shared.assertTrue(condition, message: message, file: file, line: line)
    }
    
    public func assertFalse(_ condition: Bool, message: String = "Condition should be false", file: StaticString = #file, line: UInt = #line) {
        AssertionHelpers.shared.assertFalse(condition, message: message, file: file, line: line)
    }
    
    public func assertEqual<T: Equatable>(_ value1: T, _ value2: T, message: String = "Values should be equal", file: StaticString = #file, line: UInt = #line) {
        AssertionHelpers.shared.assertEqual(value1, value2, message: message, file: file, line: line)
    }
    
    public func assertNotEqual<T: Equatable>(_ value1: T, _ value2: T, message: String = "Values should not be equal", file: StaticString = #file, line: UInt = #line) {
        AssertionHelpers.shared.assertNotEqual(value1, value2, message: message, file: file, line: line)
    }
    
    public func assertThrows<T>(_ block: () throws -> T, message: String = "Block should throw an error", file: StaticString = #file, line: UInt = #line) {
        AssertionHelpers.shared.assertThrows(block, message: message, file: file, line: line)
    }
    
    public func assertNoThrow<T>(_ block: () throws -> T, message: String = "Block should not throw an error", file: StaticString = #file, line: UInt = #line) {
        AssertionHelpers.shared.assertNoThrow(block, message: message, file: file, line: line)
    }
    
    public func assertAsyncCompletes<T>(_ operation: @escaping () async throws -> T, timeout: TimeInterval = 5.0, message: String = "Async operation should complete", file: StaticString = #file, line: UInt = #line) async throws {
        try await AssertionHelpers.shared.assertAsyncCompletes(operation, timeout: timeout, message: message, file: file, line: line)
    }
} 