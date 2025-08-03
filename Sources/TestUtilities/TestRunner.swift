import Foundation
import XCTest

// MARK: - Test Runner
public class TestRunner {
    
    // MARK: - Singleton
    public static let shared = TestRunner()
    
    // MARK: - Private Properties
    private var testSuites: [String: TestSuite] = [:]
    private var isRunning = false
    private var currentSuite: TestSuite?
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Public Methods
    
    /// Initialize the test runner
    public static func initialize() {
        shared.setupEnvironment()
    }
    
    /// Set up test runner environment
    public func setupEnvironment() {
        print("✅ TestRunner initialized successfully")
    }
    
    /// Run all test suites
    public func runAllTests() async throws -> TestRunnerReport {
        let startTime = Date()
        isRunning = true
        
        var results: [TestSuiteResult] = []
        
        for (name, suite) in testSuites {
            let result = try await runTestSuite(name, suite: suite)
            results.append(result)
        }
        
        isRunning = false
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        return TestRunnerReport(
            totalSuites: testSuites.count,
            totalTests: results.reduce(0) { $0 + $1.totalTests },
            passedTests: results.reduce(0) { $0 + $1.passedTests },
            failedTests: results.reduce(0) { $0 + $1.failedTests },
            duration: duration,
            results: results
        )
    }
    
    /// Run specific test suite
    public func runTestSuite(_ name: String) async throws -> TestSuiteResult {
        guard let suite = testSuites[name] else {
            throw TestRunnerError.suiteNotFound(name)
        }
        
        return try await runTestSuite(name, suite: suite)
    }
    
    /// Add test suite
    public func addTestSuite(_ suite: TestSuite, name: String) {
        testSuites[name] = suite
    }
    
    /// Remove test suite
    public func removeTestSuite(_ name: String) {
        testSuites.removeValue(forKey: name)
    }
    
    /// Get test suite
    public func getTestSuite(_ name: String) -> TestSuite? {
        return testSuites[name]
    }
    
    /// Get all test suite names
    public func getAllTestSuiteNames() -> [String] {
        return Array(testSuites.keys)
    }
    
    /// Clear all test suites
    public func clearTestSuites() {
        testSuites.removeAll()
    }
    
    /// Check if test runner is running
    public func isTestRunnerRunning() -> Bool {
        return isRunning
    }
    
    /// Stop test runner
    public func stopTestRunner() {
        isRunning = false
    }
    
    // MARK: - Private Methods
    
    private func runTestSuite(_ name: String, suite: TestSuite) async throws -> TestSuiteResult {
        let startTime = Date()
        currentSuite = suite
        
        var testResults: [TestResult] = []
        
        for test in suite.tests {
            let result = try await runTest(test)
            testResults.append(result)
        }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        let totalTests = testResults.count
        let passedTests = testResults.filter { $0.status == .passed }.count
        let failedTests = testResults.filter { $0.status == .failed }.count
        
        currentSuite = nil
        
        return TestSuiteResult(
            name: name,
            totalTests: totalTests,
            passedTests: passedTests,
            failedTests: failedTests,
            duration: duration,
            results: testResults
        )
    }
    
    private func runTest(_ test: TestCase) async throws -> TestResult {
        let startTime = Date()
        
        do {
            try await test.execute()
            let endTime = Date()
            let duration = endTime.timeIntervalSince(startTime)
            
            return TestResult(
                name: test.name,
                status: .passed,
                duration: duration
            )
        } catch {
            let endTime = Date()
            let duration = endTime.timeIntervalSince(startTime)
            
            return TestResult(
                name: test.name,
                status: .failed,
                duration: duration,
                error: error
            )
        }
    }
}

// MARK: - Supporting Types

/// Test Suite
public struct TestSuite {
    public let name: String
    public let tests: [TestCase]
    public let setup: (() async throws -> Void)?
    public let teardown: (() async throws -> Void)?
    
    public init(name: String, tests: [TestCase], setup: (() async throws -> Void)? = nil, teardown: (() async throws -> Void)? = nil) {
        self.name = name
        self.tests = tests
        self.setup = setup
        self.teardown = teardown
    }
}

/// Test Case
public struct TestCase {
    public let name: String
    public let execute: () async throws -> Void
    
    public init(name: String, execute: @escaping () async throws -> Void) {
        self.name = name
        self.execute = execute
    }
}

/// Test Suite Result
public struct TestSuiteResult {
    public let name: String
    public let totalTests: Int
    public let passedTests: Int
    public let failedTests: Int
    public let duration: TimeInterval
    public let results: [TestResult]
    
    public var successRate: Double {
        return totalTests > 0 ? Double(passedTests) / Double(totalTests) : 0.0
    }
    
    public init(name: String, totalTests: Int, passedTests: Int, failedTests: Int, duration: TimeInterval, results: [TestResult]) {
        self.name = name
        self.totalTests = totalTests
        self.passedTests = passedTests
        self.failedTests = failedTests
        self.duration = duration
        self.results = results
    }
}

/// Test Runner Report
public struct TestRunnerReport {
    public let totalSuites: Int
    public let totalTests: Int
    public let passedTests: Int
    public let failedTests: Int
    public let duration: TimeInterval
    public let results: [TestSuiteResult]
    
    public var successRate: Double {
        return totalTests > 0 ? Double(passedTests) / Double(totalTests) : 0.0
    }
    
    public init(totalSuites: Int, totalTests: Int, passedTests: Int, failedTests: Int, duration: TimeInterval, results: [TestSuiteResult]) {
        self.totalSuites = totalSuites
        self.totalTests = totalTests
        self.passedTests = passedTests
        self.failedTests = failedTests
        self.duration = duration
        self.results = results
    }
}

/// Test Runner Error
public enum TestRunnerError: LocalizedError {
    case suiteNotFound(String)
    case testExecutionFailed(String)
    case runnerNotInitialized
    case runnerAlreadyRunning
    
    public var errorDescription: String? {
        switch self {
        case .suiteNotFound(let name):
            return "Test suite not found: \(name)"
        case .testExecutionFailed(let message):
            return "Test execution failed: \(message)"
        case .runnerNotInitialized:
            return "Test runner not initialized"
        case .runnerAlreadyRunning:
            return "Test runner is already running"
        }
    }
} 