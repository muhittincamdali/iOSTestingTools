import Foundation
import XCTest

// MARK: - Test Reporting
public class TestReporting {
    
    // MARK: - Singleton
    public static let shared = TestReporting()
    
    // MARK: - Private Properties
    private var reports: [TestReport] = []
    private var reportFormatters: [ReportFormat: ReportFormatter] = [:]
    
    // MARK: - Initialization
    private init() {
        setupDefaultFormatters()
    }
    
    // MARK: - Public Methods
    
    /// Generate test report
    public func generateReport(from results: [TestResult]) -> TestReport {
        let totalTests = results.count
        let passedTests = results.filter { $0.status == .passed }.count
        let failedTests = results.filter { $0.status == .failed }.count
        let skippedTests = results.filter { $0.status == .skipped }.count
        
        let totalDuration = results.reduce(0) { $0 + $1.duration }
        let successRate = totalTests > 0 ? Double(passedTests) / Double(totalTests) : 0.0
        
        let report = TestReport(
            totalTests: totalTests,
            passedTests: passedTests,
            failedTests: failedTests,
            skippedTests: skippedTests,
            totalDuration: totalDuration,
            successRate: successRate,
            results: results,
            timestamp: Date()
        )
        
        reports.append(report)
        return report
    }
    
    /// Generate detailed report
    public func generateDetailedReport(from results: [TestResult]) -> DetailedTestReport {
        let basicReport = generateReport(from: results)
        
        let testCategories = categorizeTests(results)
        let performanceMetrics = calculatePerformanceMetrics(results)
        let errorAnalysis = analyzeErrors(results)
        
        return DetailedTestReport(
            basicReport: basicReport,
            testCategories: testCategories,
            performanceMetrics: performanceMetrics,
            errorAnalysis: errorAnalysis
        )
    }
    
    /// Export report to file
    public func exportReport(_ report: TestReport, format: ReportFormat, to file: String) throws {
        guard let formatter = reportFormatters[format] else {
            throw TestReportingError.unsupportedFormat(format)
        }
        
        let content = formatter.format(report)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(file)
        
        try content.write(to: url, atomically: true, encoding: .utf8)
    }
    
    /// Export detailed report to file
    public func exportDetailedReport(_ report: DetailedTestReport, format: ReportFormat, to file: String) throws {
        guard let formatter = reportFormatters[format] else {
            throw TestReportingError.unsupportedFormat(format)
        }
        
        let content = formatter.formatDetailed(report)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(file)
        
        try content.write(to: url, atomically: true, encoding: .utf8)
    }
    
    /// Get all reports
    public func getAllReports() -> [TestReport] {
        return reports
    }
    
    /// Clear all reports
    public func clearReports() {
        reports.removeAll()
    }
    
    /// Register custom formatter
    public func registerFormatter(_ formatter: ReportFormatter, for format: ReportFormat) {
        reportFormatters[format] = formatter
    }
    
    // MARK: - Private Methods
    
    private func setupDefaultFormatters() {
        reportFormatters[.text] = TextReportFormatter()
        reportFormatters[.json] = JSONReportFormatter()
        reportFormatters[.html] = HTMLReportFormatter()
        reportFormatters[.xml] = XMLReportFormatter()
    }
    
    private func categorizeTests(_ results: [TestResult]) -> [String: Int] {
        var categories: [String: Int] = [:]
        
        for result in results {
            let category = extractCategory(from: result.name)
            categories[category, default: 0] += 1
        }
        
        return categories
    }
    
    private func extractCategory(from testName: String) -> String {
        let components = testName.components(separatedBy: "_")
        return components.first ?? "Unknown"
    }
    
    private func calculatePerformanceMetrics(_ results: [TestResult]) -> PerformanceMetrics {
        let durations = results.map { $0.duration }
        let avgDuration = durations.reduce(0, +) / Double(durations.count)
        let minDuration = durations.min() ?? 0
        let maxDuration = durations.max() ?? 0
        
        return PerformanceMetrics(
            averageDuration: avgDuration,
            minDuration: minDuration,
            maxDuration: maxDuration,
            totalDuration: durations.reduce(0, +)
        )
    }
    
    private func analyzeErrors(_ results: [TestResult]) -> ErrorAnalysis {
        let failedResults = results.filter { $0.status == .failed }
        var errorTypes: [String: Int] = [:]
        
        for result in failedResults {
            if let error = result.error {
                let errorType = String(describing: type(of: error))
                errorTypes[errorType, default: 0] += 1
            }
        }
        
        return ErrorAnalysis(
            totalErrors: failedResults.count,
            errorTypes: errorTypes,
            mostCommonError: errorTypes.max(by: { $0.value < $1.value })?.key
        )
    }
}

// MARK: - Supporting Types

/// Test Report
public struct TestReport {
    public let totalTests: Int
    public let passedTests: Int
    public let failedTests: Int
    public let skippedTests: Int
    public let totalDuration: TimeInterval
    public let successRate: Double
    public let results: [TestResult]
    public let timestamp: Date
    
    public init(totalTests: Int, passedTests: Int, failedTests: Int, skippedTests: Int, totalDuration: TimeInterval, successRate: Double, results: [TestResult], timestamp: Date) {
        self.totalTests = totalTests
        self.passedTests = passedTests
        self.failedTests = failedTests
        self.skippedTests = skippedTests
        self.totalDuration = totalDuration
        self.successRate = successRate
        self.results = results
        self.timestamp = timestamp
    }
}

/// Detailed Test Report
public struct DetailedTestReport {
    public let basicReport: TestReport
    public let testCategories: [String: Int]
    public let performanceMetrics: PerformanceMetrics
    public let errorAnalysis: ErrorAnalysis
    
    public init(basicReport: TestReport, testCategories: [String: Int], performanceMetrics: PerformanceMetrics, errorAnalysis: ErrorAnalysis) {
        self.basicReport = basicReport
        self.testCategories = testCategories
        self.performanceMetrics = performanceMetrics
        self.errorAnalysis = errorAnalysis
    }
}

/// Performance Metrics
public struct PerformanceMetrics {
    public let averageDuration: TimeInterval
    public let minDuration: TimeInterval
    public let maxDuration: TimeInterval
    public let totalDuration: TimeInterval
    
    public init(averageDuration: TimeInterval, minDuration: TimeInterval, maxDuration: TimeInterval, totalDuration: TimeInterval) {
        self.averageDuration = averageDuration
        self.minDuration = minDuration
        self.maxDuration = maxDuration
        self.totalDuration = totalDuration
    }
}

/// Error Analysis
public struct ErrorAnalysis {
    public let totalErrors: Int
    public let errorTypes: [String: Int]
    public let mostCommonError: String?
    
    public init(totalErrors: Int, errorTypes: [String: Int], mostCommonError: String?) {
        self.totalErrors = totalErrors
        self.errorTypes = errorTypes
        self.mostCommonError = mostCommonError
    }
}

/// Report Format
public enum ReportFormat: String, CaseIterable {
    case text = "txt"
    case json = "json"
    case html = "html"
    case xml = "xml"
}

/// Report Formatter Protocol
public protocol ReportFormatter {
    func format(_ report: TestReport) -> String
    func formatDetailed(_ report: DetailedTestReport) -> String
}

/// Text Report Formatter
public class TextReportFormatter: ReportFormatter {
    public func format(_ report: TestReport) -> String {
        return """
        Test Report
        ===========
        Date: \(report.timestamp)
        Total Tests: \(report.totalTests)
        Passed: \(report.passedTests)
        Failed: \(report.failedTests)
        Skipped: \(report.skippedTests)
        Success Rate: \(String(format: "%.2f%%", report.successRate * 100))
        Total Duration: \(String(format: "%.2fs", report.totalDuration))
        """
    }
    
    public func formatDetailed(_ report: DetailedTestReport) -> String {
        let basic = format(report.basicReport)
        
        let categories = report.testCategories.map { "  \($0.key): \($0.value)" }.joined(separator: "\n")
        let performance = """
        Performance Metrics:
          Average Duration: \(String(format: "%.2fs", report.performanceMetrics.averageDuration))
          Min Duration: \(String(format: "%.2fs", report.performanceMetrics.minDuration))
          Max Duration: \(String(format: "%.2fs", report.performanceMetrics.maxDuration))
        """
        
        return basic + "\n\n" + categories + "\n\n" + performance
    }
}

/// JSON Report Formatter
public class JSONReportFormatter: ReportFormatter {
    public func format(_ report: TestReport) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(report)
            return String(data: data, encoding: .utf8) ?? "{}"
        } catch {
            return "{}"
        }
    }
    
    public func formatDetailed(_ report: DetailedTestReport) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(report)
            return String(data: data, encoding: .utf8) ?? "{}"
        } catch {
            return "{}"
        }
    }
}

/// HTML Report Formatter
public class HTMLReportFormatter: ReportFormatter {
    public func format(_ report: TestReport) -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Test Report</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { background-color: #f0f0f0; padding: 10px; }
                .metric { margin: 10px 0; }
                .success { color: green; }
                .failure { color: red; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>Test Report</h1>
                <p>Date: \(report.timestamp)</p>
            </div>
            <div class="metric">
                <strong>Total Tests:</strong> \(report.totalTests)<br>
                <strong class="success">Passed:</strong> \(report.passedTests)<br>
                <strong class="failure">Failed:</strong> \(report.failedTests)<br>
                <strong>Skipped:</strong> \(report.skippedTests)<br>
                <strong>Success Rate:</strong> \(String(format: "%.2f%%", report.successRate * 100))<br>
                <strong>Total Duration:</strong> \(String(format: "%.2fs", report.totalDuration))
            </div>
        </body>
        </html>
        """
    }
    
    public func formatDetailed(_ report: DetailedTestReport) -> String {
        return format(report.basicReport) // Simplified for brevity
    }
}

/// XML Report Formatter
public class XMLReportFormatter: ReportFormatter {
    public func format(_ report: TestReport) -> String {
        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <testReport>
            <timestamp>\(report.timestamp)</timestamp>
            <summary>
                <totalTests>\(report.totalTests)</totalTests>
                <passedTests>\(report.passedTests)</passedTests>
                <failedTests>\(report.failedTests)</failedTests>
                <skippedTests>\(report.skippedTests)</skippedTests>
                <successRate>\(report.successRate)</successRate>
                <totalDuration>\(report.totalDuration)</totalDuration>
            </summary>
        </testReport>
        """
    }
    
    public func formatDetailed(_ report: DetailedTestReport) -> String {
        return format(report.basicReport) // Simplified for brevity
    }
}

/// Test Reporting Error
public enum TestReportingError: LocalizedError {
    case unsupportedFormat(ReportFormat)
    case exportFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .unsupportedFormat(let format):
            return "Unsupported report format: \(format.rawValue)"
        case .exportFailed(let message):
            return "Export failed: \(message)"
        }
    }
} 