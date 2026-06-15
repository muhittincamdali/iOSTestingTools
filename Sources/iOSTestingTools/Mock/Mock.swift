import Foundation

public actor Mock<T: Sendable> {
    private var recordedCalls: [String: Int] = [:]
    private var results: [String: T] = [:]
    
    public init() {}
    
    public func record(_ function: String = #function) {
        recordedCalls[function, default: 0] += 1
    }
    
    public func stub(_ function: String, result: T) {
        results[function] = result
    }
    
    public func result(for function: String) -> T? {
        return results[function]
    }
    
    public func callCount(for function: String) -> Int {
        return recordedCalls[function] ?? 0
    }
    
    public func reset() {
        recordedCalls.removeAll()
        results.removeAll()
    }
}
