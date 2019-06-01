# Integration Testing Guide

This guide explains how to write and run integration tests using iOSTestingTools.

## Writing Integration Tests

1. Import the framework:
   ```swift
   import iOSTestingTools
   ```
2. Create a test class inheriting from `XCTestCase`.
3. Use the provided integration test helpers and API/database utilities.

## Example

```swift
import iOSTestingTools

class APIIntegrationTests: XCTestCase {
    var apiClient: APITestClient!

    override func setUp() {
        super.setUp()
        apiClient = APITestClient(baseURL: "https://api.example.com")
    }

    func testUserAPI() async throws {
        let userData = ["name": "John Doe", "email": "john@example.com"]
        let response = try await apiClient.post("/users", data: userData)
        XCTAssertEqual(response.statusCode, 201)
        XCTAssertNotNil(response.data["id"])
    }
}
```

## Database Testing

Use `DatabaseTester` to set up and query test data.

```swift
let databaseTester = DatabaseTester()
try await databaseTester.setupTestData()
let users = try await databaseTester.query("SELECT * FROM users")
```

## Network Simulation

Use `NetworkSimulator` to simulate network conditions:

```swift
let networkSimulator = NetworkSimulator()
try await networkSimulator.simulateDisconnection(duration: 2.0)
```

## Best Practices

- Test integration points between modules and services.
- Use test databases and mock APIs for isolation.
- Clean up test data after each test.
- Simulate real-world network conditions.