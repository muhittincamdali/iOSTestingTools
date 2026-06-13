import Foundation\n\npublic enum TestingTools {\n    public static let version = "2.0.0"\n}\n\npublic enum TestExpectationResult: Sendable {\n    case success\n    case failure(String)\n}
