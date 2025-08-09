# Mocking Guide

<!-- TOC START -->
## Table of Contents
- [Mocking Guide](#mocking-guide)
- [Overview](#overview)
- [Getting Started](#getting-started)
  - [Basic Mocking](#basic-mocking)
- [Advanced Mocking](#advanced-mocking)
  - [Method Verification](#method-verification)
- [Best Practices](#best-practices)
<!-- TOC END -->


## Overview

The Mocking Guide provides comprehensive instructions for using the mocking framework in iOS unit tests.

## Getting Started

### Basic Mocking

```swift
// Create a mock object
let mockNetworkService = MockNetworkService()

// Configure mock behavior
mockNetworkService.mockResponse = AuthResponse(token: "test_token")

// Use mock in test
let userManager = UserManager(networkService: mockNetworkService)
let result = try await userManager.authenticate(email: "user@example.com", password: "password")

// Verify mock interactions
XCTAssertEqual(mockNetworkService.callCount, 1)
XCTAssertTrue(result.isAuthenticated)
```

## Advanced Mocking

### Method Verification

```swift
// Verify method was called
mockNetworkService.verify(method: "authenticate", called: 1)

// Verify method with specific parameters
mockNetworkService.verify(method: "authenticate", withParameters: ["email": "user@example.com"])

// Verify method was not called
mockNetworkService.verify(method: "logout", called: 0)
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
