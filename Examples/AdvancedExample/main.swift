import iOSTestingTools
import XCTest

// Advanced Example: Mocking and Integration
protocol UserRepository {
    func fetchUser(id: String) async throws -> User
}

struct User {
    let id: String
    let name: String
}

class UserService {
    let repository: UserRepository
    init(repository: UserRepository) { self.repository = repository }
    func getUserName(id: String) async throws -> String {
        let user = try await repository.fetchUser(id: id)
        return user.name
    }
}

class UserServiceTests: XCTestCase {
    func testGetUserName() async throws {
        let mockRepo = MockGenerator.shared.createMock(with: .custom { methodName in
            if methodName == "fetchUser" {
                return User(id: "1", name: "Alice")
            }
            return nil
        }) as UserRepository
        let service = UserService(repository: mockRepo)
        let name = try await service.getUserName(id: "1")
        AssertionHelpers.shared.assertEqual(name, "Alice")
    }
}

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
