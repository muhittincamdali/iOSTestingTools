import Foundation

public enum TestingTools {
    public static let version = "2.0.0"
}

public enum TestExpectationResult: Sendable {
    case success
    case failure(String)
}
