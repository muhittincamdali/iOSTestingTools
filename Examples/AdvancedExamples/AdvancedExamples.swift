import Foundation
import iOSTestingTools

// Advanced Examples
print("🚀 Advanced Examples")

// Example 1: Complex Unit Test with Mocking
let advancedUnitTest = AdvancedUnitTest()
advancedUnitTest.testComplexScenario(
    scenario: "user_authentication_flow",
    mockData: MockDataProvider.shared.getUserData(),
    expectedResults: ExpectedResultsProvider.shared.getAuthResults()
) { result in
    switch result {
    case .success(let testResult):
        print("✅ Advanced unit test passed")
        print("Scenario: \(testResult.scenario)")
        print("Test cases: \(testResult.testCases)")
        print("Coverage: \(testResult.coverage)%")
    case .failure(let error):
        print("❌ Advanced unit test failed: \(error)")
    }
}

// Example 2: Performance Testing
let performanceTest = PerformanceTest()
performanceTest.testApplicationPerformance(
    metrics: ["memory_usage", "cpu_usage", "battery_impact", "launch_time"],
    duration: 300 // 5 minutes
) { result in
    switch result {
    case .success(let performanceResult):
        print("✅ Performance test completed")
        print("Memory usage: \(performanceResult.memoryUsage)MB")
        print("CPU usage: \(performanceResult.cpuUsage)%")
        print("Battery impact: \(performanceResult.batteryImpact)%")
        print("Launch time: \(performanceResult.launchTime)ms")
    case .failure(let error):
        print("❌ Performance test failed: \(error)")
    }
}

// Example 3: Integration Testing
let integrationTest = IntegrationTest()
integrationTest.testFullUserJourney(
    journey: "complete_purchase_flow",
    userData: UserDataProvider.shared.getTestUser(),
    productData: ProductDataProvider.shared.getTestProducts()
) { result in
    switch result {
    case .success(let integrationResult):
        print("✅ Integration test completed")
        print("Journey: \(integrationResult.journey)")
        print("Steps completed: \(integrationResult.stepsCompleted)")
        print("Total time: \(integrationResult.totalTime)s")
    case .failure(let error):
        print("❌ Integration test failed: \(error)")
    }
}

print("✅ Advanced Examples completed")
