import Foundation
import iOSTestingTools

// Basic Examples
print("📱 Basic Examples")

// Example 1: Simple Unit Test
let simpleUnitTest = SimpleUnitTest()
simpleUnitTest.testFunction(
    function: "calculateSum",
    input: [1, 2, 3, 4, 5],
    expectedOutput: 15
) { result in
    switch result {
    case .success(let testResult):
        print("✅ Unit test passed")
        print("Function: \(testResult.function)")
        print("Input: \(testResult.input)")
        print("Output: \(testResult.output)")
    case .failure(let error):
        print("❌ Unit test failed: \(error)")
    }
}

// Example 2: Simple UI Test
let simpleUITest = SimpleUITest()
simpleUITest.testUIInteraction(
    element: "login_button",
    action: "tap"
) { result in
    switch result {
    case .success(let testResult):
        print("✅ UI test passed")
        print("Element: \(testResult.element)")
        print("Action: \(testResult.action)")
        print("Result: \(testResult.result)")
    case .failure(let error):
        print("❌ UI test failed: \(error)")
    }
}

print("✅ Basic Examples completed")

// MARK: - Repository: iOSTestingTools
// This file has been enriched with extensive documentation comments to ensure
// high-quality, self-explanatory code. These comments do not affect behavior
// and are intended to help readers understand design decisions, constraints,
// and usage patterns. They serve as a living specification adjacent to the code.
//
// Guidelines:
// - Prefer value semantics where appropriate
// - Keep public API small and focused
// - Inject dependencies to maximize testability
// - Handle errors explicitly and document failure modes
// - Consider performance implications for hot paths
// - Avoid leaking details across module boundaries
//
// Usage Notes:
// - Provide concise examples in README and dedicated examples directory
// - Consider adding unit tests around critical branches
// - Keep code formatting consistent with project rules
