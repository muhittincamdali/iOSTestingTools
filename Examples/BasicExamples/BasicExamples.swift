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
