# Mocking API

## Overview

The Mocking API provides comprehensive tools for creating and managing mock objects in iOS unit tests.

## Core Components

### MockGenerator

The main class for generating and managing mock objects.

```swift
public class MockGenerator {
    public static let shared = MockGenerator()
    
    public func generateMock<T>(for type: T.Type) -> T
    public func createMock<T>(_ type: T.Type, behavior: MockBehavior) -> T
    public func verifyMock<T>(_ mock: T, method: String, called times: Int) -> Bool
    public func resetMock<T>(_ mock: T)
}
```

## Key Features

- **Automatic Mock Generation**: Generate mocks from protocols and classes
- **Behavior Configuration**: Configure mock behavior (strict, loose, custom)
- **Method Verification**: Verify method calls and parameters
- **Mock Reset**: Reset mock state between tests
- **Stub Generation**: Generate stubs for complex objects

## Usage Examples

```swift
// Create mock network service
let mockNetworkService = MockNetworkService()

// Configure mock behavior
mockNetworkService.when(method: "authenticate")
    .withParameters(["email": "user@company.com", "password": "password123"])
    .returns(AuthResponse(token: "test_token"))

// Verify mock calls
mockNetworkService.verify(method: "authenticate", called: 1)
mockNetworkService.verify(method: "authenticate", withParameters: ["email": "user@company.com"])
```

## Best Practices

1. Use descriptive mock names
2. Configure mock behavior before test execution
3. Verify mock interactions after test completion
4. Reset mocks between tests for isolation
5. Use meaningful test data in mock responses
6. Test both success and failure scenarios
7. Avoid over-mocking in tests
8. Use mock factories for complex object creation
9. Document mock behavior expectations
10. Use mock verification for better test reliability
