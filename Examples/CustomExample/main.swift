import iOSTestingTools
import XCTest

// Custom Example: Performance Test
class DataProcessor {
    func process(_ data: [Int]) -> Int {
        return data.reduce(0, +)
    }
}

class DataProcessorTests: XCTestCase {
    func testProcessPerformance() {
        let processor = DataProcessor()
        let data = Array(0...10000)
        measure {
            let result = processor.process(data)
            AssertionHelpers.shared.assertGreaterThan(result, 0)
        }
    }
}
