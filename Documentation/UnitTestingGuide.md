# Unit Testing Guide

This guide explains how to write and run unit tests using iOSTestingTools.

## Writing Unit Tests

1. Import the framework:
   ```swift
   import iOSTestingTools
   ```
2. Create a test class inheriting from `XCTestCase`.
3. Use the provided assertion helpers and mock generators.

## Example

```swift
import iOSTestingTools

class CalculatorTests: XCTestCase {
    func testAddition() {
        let calculator = Calculator()
        let result = calculator.add(2, 3)
        AssertionHelpers.shared.assertEqual(result, 5)
    }
}
```

## Mocking

Use `MockGenerator` to create mocks for protocols and classes.

```swift
let mockRepo = MockGenerator.shared.generateMock(for: UserRepository.self)
```

## Test Data

Use `TestDataBuilder` to generate test users, products, and more.

```swift
let testUser = TestDataBuilder.shared.createTestUser()
```

## Running Tests

- Use Xcode's test navigator or run tests via command line:
  ```sh
  swift test
  ```

## Best Practices

- Aim for 100% test coverage.
- Use descriptive test names.
- Test edge cases and error conditions.
- Keep tests isolated and repeatable.