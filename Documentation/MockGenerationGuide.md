# Mock Generation Guide

This guide explains how to generate and use mocks with iOSTestingTools.

## Generating Mocks

Use `MockGenerator` to automatically generate mocks for protocols and classes.

```swift
let mockUserRepo = MockGenerator.shared.generateMock(for: UserRepository.self)
```

## Custom Mock Behavior

You can create mocks with custom behavior:

```swift
let customMock = MockGenerator.shared.createMock(with: .custom { methodName in
    if methodName == "fetchUser" {
        return TestUser(id: "42", name: "Jane", email: "jane@example.com")
    }
    return nil
})
```

## Resetting Mocks

Reset all mocks to their initial state:

```swift
MockGenerator.shared.resetMocks()
```

## Verifying Mock Calls

You can verify if a mock method was called:

```swift
let wasCalled = MockGenerator.shared.verifyMock(mockUserRepo, wasCalled: "fetchUser", times: 1)
```

## Best Practices

- Use mocks to isolate units under test.
- Define clear expectations for mock behavior.
- Reset mocks between tests to avoid state leakage.
- Use custom behaviors for complex scenarios.