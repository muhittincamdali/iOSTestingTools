# Performance Testing Guide

<!-- TOC START -->
## Table of Contents
- [Performance Testing Guide](#performance-testing-guide)
- [Writing Performance Tests](#writing-performance-tests)
- [Example](#example)
- [Memory Profiling](#memory-profiling)
- [CPU Profiling](#cpu-profiling)
- [Best Practices](#best-practices)
<!-- TOC END -->


This guide explains how to write and run performance tests using iOSTestingTools.

## Writing Performance Tests

1. Import the framework:
   ```swift
   import iOSTestingTools
   ```
2. Create a test class inheriting from `XCTestCase`.
3. Use the provided performance test helpers and profilers.

## Example

```swift
import iOSTestingTools

class PerformanceTests: XCTestCase {
    func testUserListPerformance() {
        measure {
            let users = try? UserService.shared.fetchUsers()
            XCTAssertNotNil(users)
        }
    }
}
```

## Memory Profiling

Use `MemoryProfiler` to monitor memory usage:

```swift
let memoryProfiler = MemoryProfiler()
memoryProfiler.startProfiling()
// ... run code ...
let memoryUsage = memoryProfiler.stopProfiling()
```

## CPU Profiling

Use `CPUProfiler` to monitor CPU usage:

```swift
let cpuProfiler = CPUProfiler()
cpuProfiler.startProfiling()
// ... run code ...
cpuProfiler.stopProfiling()
```

## Best Practices

- Profile memory and CPU usage for critical code paths.
- Set performance budgets and monitor regressions.
- Use benchmarks for repeatable performance tests.
- Optimize code based on profiling results.