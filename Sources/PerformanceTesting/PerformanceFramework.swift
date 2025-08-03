import Foundation
import XCTest

// MARK: - Performance Test Framework
public class PerformanceFramework {
    
    // MARK: - Singleton
    public static let shared = PerformanceFramework()
    
    // MARK: - Private Properties
    private var memoryProfiler: MemoryProfiler?
    private var cpuProfiler: CPUProfiler?
    private var batteryTester: BatteryTester?
    private var performanceMetrics: [String: PerformanceMetric] = [:]
    
    // MARK: - Initialization
    private init() {
        setupProfilers()
    }
    
    // MARK: - Public Methods
    
    /// Initialize the performance test framework
    public static func initialize() {
        shared.setupEnvironment()
    }
    
    /// Set up performance testing environment
    public func setupEnvironment() {
        memoryProfiler = MemoryProfiler()
        cpuProfiler = CPUProfiler()
        batteryTester = BatteryTester()
        
        print("✅ PerformanceFramework initialized successfully")
    }
    
    /// Measure performance of an operation
    public func measurePerformance<T>(operation: () throws -> T, name: String = "Performance Test") throws -> PerformanceResult {
        let startTime = Date()
        let startMemory = memoryProfiler?.getCurrentMemoryUsage() ?? 0
        let startCPU = cpuProfiler?.getCurrentCPUUsage() ?? 0.0
        
        do {
            let result = try operation()
            
            let endTime = Date()
            let endMemory = memoryProfiler?.getCurrentMemoryUsage() ?? 0
            let endCPU = cpuProfiler?.getCurrentCPUUsage() ?? 0.0
            
            let duration = endTime.timeIntervalSince(startTime)
            let memoryDelta = endMemory - startMemory
            let cpuDelta = endCPU - startCPU
            
            let metric = PerformanceMetric(
                name: name,
                duration: duration,
                memoryUsage: endMemory,
                memoryDelta: memoryDelta,
                cpuUsage: endCPU,
                cpuDelta: cpuDelta
            )
            
            performanceMetrics[name] = metric
            
            return PerformanceResult(
                metric: metric,
                success: true,
                error: nil
            )
        } catch {
            let endTime = Date()
            let duration = endTime.timeIntervalSince(startTime)
            
            let metric = PerformanceMetric(
                name: name,
                duration: duration,
                memoryUsage: 0,
                memoryDelta: 0,
                cpuUsage: 0,
                cpuDelta: 0
            )
            
            return PerformanceResult(
                metric: metric,
                success: false,
                error: error
            )
        }
    }
    
    /// Measure async performance of an operation
    public func measureAsyncPerformance<T>(operation: @escaping () async throws -> T, name: String = "Async Performance Test") async throws -> PerformanceResult {
        let startTime = Date()
        let startMemory = memoryProfiler?.getCurrentMemoryUsage() ?? 0
        let startCPU = cpuProfiler?.getCurrentCPUUsage() ?? 0.0
        
        do {
            let result = try await operation()
            
            let endTime = Date()
            let endMemory = memoryProfiler?.getCurrentMemoryUsage() ?? 0
            let endCPU = cpuProfiler?.getCurrentCPUUsage() ?? 0.0
            
            let duration = endTime.timeIntervalSince(startTime)
            let memoryDelta = endMemory - startMemory
            let cpuDelta = endCPU - startCPU
            
            let metric = PerformanceMetric(
                name: name,
                duration: duration,
                memoryUsage: endMemory,
                memoryDelta: memoryDelta,
                cpuUsage: endCPU,
                cpuDelta: cpuDelta
            )
            
            performanceMetrics[name] = metric
            
            return PerformanceResult(
                metric: metric,
                success: true,
                error: nil
            )
        } catch {
            let endTime = Date()
            let duration = endTime.timeIntervalSince(startTime)
            
            let metric = PerformanceMetric(
                name: name,
                duration: duration,
                memoryUsage: 0,
                memoryDelta: 0,
                cpuUsage: 0,
                cpuDelta: 0
            )
            
            return PerformanceResult(
                metric: metric,
                success: false,
                error: error
            )
        }
    }
    
    /// Run performance benchmark
    public func runBenchmark<T>(operation: () throws -> T, iterations: Int = 100, name: String = "Benchmark") throws -> BenchmarkResult {
        var results: [PerformanceResult] = []
        var totalDuration: TimeInterval = 0
        var totalMemory: UInt64 = 0
        var totalCPU: Double = 0
        
        for i in 0..<iterations {
            let result = try measurePerformance(operation: operation, name: "\(name)_\(i)")
            results.append(result)
            
            if result.success {
                totalDuration += result.metric.duration
                totalMemory += result.metric.memoryUsage
                totalCPU += result.metric.cpuUsage
            }
        }
        
        let averageDuration = totalDuration / Double(iterations)
        let averageMemory = totalMemory / UInt64(iterations)
        let averageCPU = totalCPU / Double(iterations)
        
        let successfulResults = results.filter { $0.success }
        let successRate = Double(successfulResults.count) / Double(iterations)
        
        return BenchmarkResult(
            name: name,
            iterations: iterations,
            successRate: successRate,
            averageDuration: averageDuration,
            averageMemoryUsage: averageMemory,
            averageCPUUsage: averageCPU,
            results: results
        )
    }
    
    /// Run async performance benchmark
    public func runAsyncBenchmark<T>(operation: @escaping () async throws -> T, iterations: Int = 100, name: String = "Async Benchmark") async throws -> BenchmarkResult {
        var results: [PerformanceResult] = []
        var totalDuration: TimeInterval = 0
        var totalMemory: UInt64 = 0
        var totalCPU: Double = 0
        
        for i in 0..<iterations {
            let result = try await measureAsyncPerformance(operation: operation, name: "\(name)_\(i)")
            results.append(result)
            
            if result.success {
                totalDuration += result.metric.duration
                totalMemory += result.metric.memoryUsage
                totalCPU += result.metric.cpuUsage
            }
        }
        
        let averageDuration = totalDuration / Double(iterations)
        let averageMemory = totalMemory / UInt64(iterations)
        let averageCPU = totalCPU / Double(iterations)
        
        let successfulResults = results.filter { $0.success }
        let successRate = Double(successfulResults.count) / Double(iterations)
        
        return BenchmarkResult(
            name: name,
            iterations: iterations,
            successRate: successRate,
            averageDuration: averageDuration,
            averageMemoryUsage: averageMemory,
            averageCPUUsage: averageCPU,
            results: results
        )
    }
    
    /// Get performance metrics
    public func getPerformanceMetrics() -> [String: PerformanceMetric] {
        return performanceMetrics
    }
    
    /// Clear performance metrics
    public func clearPerformanceMetrics() {
        performanceMetrics.removeAll()
    }
    
    /// Get memory usage
    public func getMemoryUsage() -> UInt64 {
        return memoryProfiler?.getCurrentMemoryUsage() ?? 0
    }
    
    /// Get CPU usage
    public func getCPUUsage() -> Double {
        return cpuProfiler?.getCurrentCPUUsage() ?? 0.0
    }
    
    /// Get battery usage
    public func getBatteryUsage() -> BatteryUsage {
        return batteryTester?.getCurrentBatteryUsage() ?? BatteryUsage(level: 0.0, isCharging: false)
    }
    
    /// Start performance monitoring
    public func startMonitoring() {
        memoryProfiler?.startMonitoring()
        cpuProfiler?.startMonitoring()
        batteryTester?.startMonitoring()
    }
    
    /// Stop performance monitoring
    public func stopMonitoring() -> PerformanceReport {
        let memoryReport = memoryProfiler?.stopMonitoring()
        let cpuReport = cpuProfiler?.stopMonitoring()
        let batteryReport = batteryTester?.stopMonitoring()
        
        return PerformanceReport(
            memoryReport: memoryReport,
            cpuReport: cpuReport,
            batteryReport: batteryReport
        )
    }
    
    // MARK: - Private Methods
    
    private func setupProfilers() {
        memoryProfiler = MemoryProfiler()
        cpuProfiler = CPUProfiler()
        batteryTester = BatteryTester()
    }
}

// MARK: - Supporting Types

/// Performance Metric
public struct PerformanceMetric {
    public let name: String
    public let duration: TimeInterval
    public let memoryUsage: UInt64
    public let memoryDelta: Int64
    public let cpuUsage: Double
    public let cpuDelta: Double
    
    public init(name: String, duration: TimeInterval, memoryUsage: UInt64, memoryDelta: Int64, cpuUsage: Double, cpuDelta: Double) {
        self.name = name
        self.duration = duration
        self.memoryUsage = memoryUsage
        self.memoryDelta = memoryDelta
        self.cpuUsage = cpuUsage
        self.cpuDelta = cpuDelta
    }
}

/// Performance Result
public struct PerformanceResult {
    public let metric: PerformanceMetric
    public let success: Bool
    public let error: Error?
    
    public init(metric: PerformanceMetric, success: Bool, error: Error? = nil) {
        self.metric = metric
        self.success = success
        self.error = error
    }
}

/// Benchmark Result
public struct BenchmarkResult {
    public let name: String
    public let iterations: Int
    public let successRate: Double
    public let averageDuration: TimeInterval
    public let averageMemoryUsage: UInt64
    public let averageCPUUsage: Double
    public let results: [PerformanceResult]
    
    public init(name: String, iterations: Int, successRate: Double, averageDuration: TimeInterval, averageMemoryUsage: UInt64, averageCPUUsage: Double, results: [PerformanceResult]) {
        self.name = name
        self.iterations = iterations
        self.successRate = successRate
        self.averageDuration = averageDuration
        self.averageMemoryUsage = averageMemoryUsage
        self.averageCPUUsage = averageCPUUsage
        self.results = results
    }
}

/// Performance Report
public struct PerformanceReport {
    public let memoryReport: MemoryReport?
    public let cpuReport: CPUReport?
    public let batteryReport: BatteryReport?
    
    public init(memoryReport: MemoryReport?, cpuReport: CPUReport?, batteryReport: BatteryReport?) {
        self.memoryReport = memoryReport
        self.cpuReport = cpuReport
        self.batteryReport = batteryReport
    }
}

/// Battery Usage
public struct BatteryUsage {
    public let level: Double
    public let isCharging: Bool
    
    public init(level: Double, isCharging: Bool) {
        self.level = level
        self.isCharging = isCharging
    }
}

/// Performance Test Error
public enum PerformanceTestError: LocalizedError {
    case profilerNotInitialized
    case measurementFailed(String)
    case timeout(String)
    case memoryLeak(String)
    case cpuOverload(String)
    
    public var errorDescription: String? {
        switch self {
        case .profilerNotInitialized:
            return "Performance profiler not initialized"
        case .measurementFailed(let message):
            return "Performance measurement failed: \(message)"
        case .timeout(let message):
            return "Performance test timeout: \(message)"
        case .memoryLeak(let message):
            return "Memory leak detected: \(message)"
        case .cpuOverload(let message):
            return "CPU overload detected: \(message)"
        }
    }
} 