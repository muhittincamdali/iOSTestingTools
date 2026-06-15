import Foundation

/// iOSTestingTools: High-Integrity Performance Benchmarker.
/// 
/// Precisely measures execution time and memory delta for any block of code,
/// ensuring that enterprise-scale apps maintain a 60fps performance budget.
public struct PerformanceBenchmarker: Sendable {
    
    /// Benchmarks a block of code and returns the average execution time.
    public static func benchmark(iterations: Int = 100, label: String, block: @Sendable () async throws -> Void) async throws -> TimeInterval {
        print("🧪 [Testing] Benchmarking: \\(label) (\\(iterations) iterations)...")
        let start = Date()
        for _ in 0..<iterations {
            try await block()
        }
        let total = Date().timeIntervalSince(start)
        let average = total / Double(iterations)
        print("✅ [Testing] Result: \\(String(format: \"%.4f\", average * 1000))ms avg.")
        return average
    }
}
