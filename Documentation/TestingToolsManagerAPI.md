# Testing Tools Manager API

## Overview

The `TestingToolsManager` is the core component of the iOS Testing Tools framework that orchestrates all testing activities and provides a unified interface for managing different types of tests.

## Core Classes

### TestingToolsManager

The main manager class that coordinates all testing activities.

```swift
public class TestingToolsManager {
    public static let shared = TestingToolsManager()
    
    private var unitTestManager: UnitTestManager?
    private var uiTestManager: UITestManager?
    private var performanceTestManager: PerformanceTestManager?
    private var automationManager: TestAutomationManager?
    
    public init()
}
```

#### Methods

##### start(with configuration: TestingToolsConfiguration)

Initializes and starts the testing tools manager with the specified configuration.

```swift
public func start(with configuration: TestingToolsConfiguration) throws
```

**Parameters:**
- `configuration`: The configuration object containing all testing settings

**Throws:**
- `TestingToolsError.invalidConfiguration`: When configuration is invalid
- `TestingToolsError.initializationFailed`: When initialization fails

**Example:**
```swift
let manager = TestingToolsManager.shared
let config = TestingToolsConfiguration()
config.enableUnitTesting = true
config.enableUITesting = true

try manager.start(with: config)
```

##### configure(_ configuration: TestingToolsConfiguration)

Updates the configuration of the testing tools manager.

```swift
public func configure(_ configuration: TestingToolsConfiguration)
```

##### runAllTests(completion: @escaping (Result<TestResults, TestingToolsError>) -> Void)

Runs all enabled test types and returns comprehensive results.

```swift
public func runAllTests(completion: @escaping (Result<TestResults, TestingToolsError>) -> Void)
```

**Parameters:**
- `completion`: Closure called with test results or error

**Example:**
```swift
manager.runAllTests { result in
    switch result {
    case .success(let results):
        print("Total tests: \(results.totalTests)")
        print("Passed: \(results.passedTests)")
        print("Failed: \(results.failedTests)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

##### generateReport(format: ReportFormat) -> TestReport

Generates a comprehensive test report in the specified format.

```swift
public func generateReport(format: ReportFormat) -> TestReport
```

**Parameters:**
- `format`: The desired report format (HTML, JSON, XML, PDF)

**Returns:**
- `TestReport`: The generated test report

## Configuration

### TestingToolsConfiguration

Configuration class for the testing tools manager.

```swift
public class TestingToolsConfiguration {
    public var enableUnitTesting: Bool = false
    public var enableUITesting: Bool = false
    public var enablePerformanceTesting: Bool = false
    public var enableTestAutomation: Bool = false
    
    public var testDiscovery: TestDiscoveryConfiguration
    public var reporting: ReportingConfiguration
    public var parallelExecution: ParallelExecutionConfiguration
    
    public init()
}
```

### TestDiscoveryConfiguration

Configuration for test discovery and organization.

```swift
public class TestDiscoveryConfiguration {
    public var enableAutoDiscovery: Bool = true
    public var enableTestOrganization: Bool = true
    public var enableTestReporting: Bool = true
    public var testPatterns: [String] = ["*Tests.swift", "*Test.swift"]
    public var excludePatterns: [String] = ["*Mock*", "*Stub*"]
}
```

## Error Handling

### TestingToolsError

Enumeration of possible errors that can occur during testing operations.

```swift
public enum TestingToolsError: Error, LocalizedError {
    case invalidConfiguration
    case initializationFailed
    case testExecutionFailed(String)
    case reportGenerationFailed
    case unsupportedTestType
    case networkError
    case timeoutError
    
    public var errorDescription: String? {
        switch self {
        case .invalidConfiguration:
            return "Invalid configuration provided"
        case .initializationFailed:
            return "Failed to initialize testing tools"
        case .testExecutionFailed(let message):
            return "Test execution failed: \(message)"
        case .reportGenerationFailed:
            return "Failed to generate test report"
        case .unsupportedTestType:
            return "Unsupported test type"
        case .networkError:
            return "Network error occurred"
        case .timeoutError:
            return "Operation timed out"
        }
    }
}
```

## Results and Reporting

### TestResults

Container for comprehensive test results from all test types.

```swift
public struct TestResults {
    public let totalTests: Int
    public let passedTests: Int
    public let failedTests: Int
    public let skippedTests: Int
    public let executionTime: TimeInterval
    public let coverage: Double
    public let unitTestResults: UnitTestResults?
    public let uiTestResults: UITestResults?
    public let performanceTestResults: PerformanceTestResults?
    public let automationResults: AutomationResults?
}
```

### TestReport

Comprehensive test report with detailed information.

```swift
public struct TestReport {
    public let summary: TestSummary
    public let details: [TestDetail]
    public let coverage: CoverageReport
    public let performance: PerformanceReport
    public let recommendations: [Recommendation]
    public let generatedAt: Date
    public let format: ReportFormat
}
```

## Usage Examples

### Basic Setup

```swift
import iOSTestingTools

// Initialize manager
let manager = TestingToolsManager.shared

// Configure testing
let config = TestingToolsConfiguration()
config.enableUnitTesting = true
config.enableUITesting = true
config.enablePerformanceTesting = true

// Start manager
try manager.start(with: config)

// Run all tests
manager.runAllTests { result in
    switch result {
    case .success(let results):
        print("✅ All tests completed")
        print("Total: \(results.totalTests)")
        print("Passed: \(results.passedTests)")
        print("Failed: \(results.failedTests)")
        
        // Generate report
        let report = manager.generateReport(format: .HTML)
        print("Report generated: \(report.summary)")
        
    case .failure(let error):
        print("❌ Testing failed: \(error)")
    }
}
```

### Advanced Configuration

```swift
// Advanced configuration
let config = TestingToolsConfiguration()

// Enable all test types
config.enableUnitTesting = true
config.enableUITesting = true
config.enablePerformanceTesting = true
config.enableTestAutomation = true

// Configure test discovery
config.testDiscovery.enableAutoDiscovery = true
config.testDiscovery.enableTestOrganization = true
config.testDiscovery.testPatterns = ["*Tests.swift", "*Test.swift"]
config.testDiscovery.excludePatterns = ["*Mock*", "*Stub*"]

// Configure reporting
config.reporting.enableDetailedReporting = true
config.reporting.enableCoverageReporting = true
config.reporting.reportFormats = [.HTML, .JSON, .PDF]

// Configure parallel execution
config.parallelExecution.enableParallelExecution = true
config.parallelExecution.maxConcurrentTests = 4
config.parallelExecution.enableTestDistribution = true

// Apply configuration
manager.configure(config)
```

## Best Practices

1. **Always use the shared instance** for consistent state management
2. **Configure before starting** to ensure proper initialization
3. **Handle errors appropriately** using the provided error types
4. **Generate reports** after test completion for analysis
5. **Use parallel execution** for faster test runs
6. **Monitor memory usage** during large test suites
7. **Implement proper cleanup** in test teardown methods

## Integration

The TestingToolsManager integrates seamlessly with:

- XCTest framework
- XCUITest framework
- CI/CD pipelines
- Test reporting tools
- Code coverage tools
- Performance monitoring tools

## Performance Considerations

- The manager uses lazy initialization for test managers
- Parallel execution is supported for improved performance
- Memory usage is optimized for large test suites
- Network requests are cached when possible
- Report generation is asynchronous to avoid blocking

## Troubleshooting

### Common Issues

1. **Initialization fails**: Check configuration validity
2. **Tests not discovered**: Verify test patterns and file locations
3. **Memory issues**: Reduce parallel execution or test batch size
4. **Network timeouts**: Increase timeout values in configuration
5. **Report generation fails**: Check file permissions and disk space

### Debug Mode

Enable debug mode for detailed logging:

```swift
let config = TestingToolsConfiguration()
config.debugMode = true
config.logLevel = .debug
```

This will provide detailed information about test discovery, execution, and reporting processes.
