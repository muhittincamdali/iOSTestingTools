import XCTest
@testable import iOSTestingTools

final class TestFrameworkTests: XCTestCase {
    
    var testFramework: TestFramework!
    
    override func setUp() {
        super.setUp()
        testFramework = TestFramework.shared
    }
    
    override func tearDown() {
        testFramework = nil
        super.tearDown()
    }
    
    func testInitialization() {
        // Given
        TestFramework.initialize()
        
        // Then
        XCTAssertNotNil(TestFramework.shared)
    }
    
    func testAddTestResult() {
        // Given
        let testResult = TestResult(
            name: "Test Case",
            status: .passed,
            duration: 1.0
        )
        
        // When
        testFramework.addTestResult(testResult)
        
        // Then
        let statistics = testFramework.getTestStatistics()
        XCTAssertEqual(statistics.total, 1)
        XCTAssertEqual(statistics.passed, 1)
        XCTAssertEqual(statistics.failed, 0)
    }
    
    func testGetTestStatistics() {
        // Given
        let passedResult = TestResult(name: "Passed Test", status: .passed, duration: 1.0)
        let failedResult = TestResult(name: "Failed Test", status: .failed, duration: 2.0)
        let skippedResult = TestResult(name: "Skipped Test", status: .skipped, duration: 0.5)
        
        // When
        testFramework.addTestResult(passedResult)
        testFramework.addTestResult(failedResult)
        testFramework.addTestResult(skippedResult)
        
        // Then
        let statistics = testFramework.getTestStatistics()
        XCTAssertEqual(statistics.total, 3)
        XCTAssertEqual(statistics.passed, 1)
        XCTAssertEqual(statistics.failed, 1)
        XCTAssertEqual(statistics.skipped, 1)
        XCTAssertEqual(statistics.successRate, 1.0/3.0, accuracy: 0.01)
    }
    
    func testRunAllTests() async throws {
        // Given
        TestFramework.initialize()
        
        // When
        let report = try await testFramework.runAllTests()
        
        // Then
        XCTAssertNotNil(report)
        XCTAssertGreaterThanOrEqual(report.totalTests, 0)
        XCTAssertGreaterThanOrEqual(report.duration, 0)
    }
    
    func testTestResultCreation() {
        // Given
        let name = "Test Case"
        let status = TestStatus.passed
        let duration: TimeInterval = 1.5
        let error = NSError(domain: "Test", code: 1, userInfo: nil)
        
        // When
        let testResult = TestResult(name: name, status: status, duration: duration, error: error)
        
        // Then
        XCTAssertEqual(testResult.name, name)
        XCTAssertEqual(testResult.status, status)
        XCTAssertEqual(testResult.duration, duration)
        XCTAssertEqual(testResult.error as? NSError, error)
        XCTAssertNotNil(testResult.timestamp)
    }
    
    func testTestReportCreation() {
        // Given
        let totalTests = 10
        let passedTests = 8
        let failedTests = 2
        let duration: TimeInterval = 5.0
        let results = [
            TestResult(name: "Test 1", status: .passed, duration: 1.0),
            TestResult(name: "Test 2", status: .failed, duration: 2.0)
        ]
        
        // When
        let report = TestReport(
            totalTests: totalTests,
            passedTests: passedTests,
            failedTests: failedTests,
            duration: duration,
            results: results
        )
        
        // Then
        XCTAssertEqual(report.totalTests, totalTests)
        XCTAssertEqual(report.passedTests, passedTests)
        XCTAssertEqual(report.failedTests, failedTests)
        XCTAssertEqual(report.duration, duration)
        XCTAssertEqual(report.results.count, results.count)
        XCTAssertEqual(report.successRate, 0.8, accuracy: 0.01)
    }
    
    func testTestStatisticsCreation() {
        // Given
        let total = 100
        let passed = 80
        let failed = 15
        let skipped = 5
        let successRate = 0.8
        
        // When
        let statistics = TestStatistics(
            total: total,
            passed: passed,
            failed: failed,
            skipped: skipped,
            successRate: successRate
        )
        
        // Then
        XCTAssertEqual(statistics.total, total)
        XCTAssertEqual(statistics.passed, passed)
        XCTAssertEqual(statistics.failed, failed)
        XCTAssertEqual(statistics.skipped, skipped)
        XCTAssertEqual(statistics.successRate, successRate)
    }
    
    func testTestStatusEnum() {
        // Test all cases of TestStatus enum
        XCTAssertNotNil(TestStatus.passed)
        XCTAssertNotNil(TestStatus.failed)
        XCTAssertNotNil(TestStatus.skipped)
    }
    
    func testTestFrameworkError() {
        // Given
        let error = TestFrameworkError.notInitialized
        
        // When & Then
        XCTAssertEqual(error.errorDescription, "Test framework not initialized")
        
        let executionError = TestFrameworkError.testExecutionFailed(NSError(domain: "Test", code: 1, userInfo: nil))
        XCTAssertTrue(executionError.errorDescription?.contains("Test execution failed") == true)
        
        let mockError = TestFrameworkError.mockGenerationFailed
        XCTAssertEqual(mockError.errorDescription, "Mock generation failed")
        
        let assertionError = TestFrameworkError.assertionFailed("Test assertion")
        XCTAssertEqual(assertionError.errorDescription, "Assertion failed: Test assertion")
    }
    
    func testPerformance() {
        measure {
            // Measure the performance of test framework operations
            for _ in 0..<1000 {
                let result = TestResult(name: "Performance Test", status: .passed, duration: 0.001)
                testFramework.addTestResult(result)
            }
        }
    }
} 