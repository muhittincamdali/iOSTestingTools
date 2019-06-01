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