import iOSTestingTools

// Basic Example: Unit Test for Calculator
class Calculator {
    func add(_ a: Int, _ b: Int) -> Int { a + b }
}

import XCTest

class CalculatorTests: XCTestCase {
    func testAddition() {
        let calculator = Calculator()
        let result = calculator.add(2, 3)
        AssertionHelpers.shared.assertEqual(result, 5)
    }
}
