# API Reference

This document provides a comprehensive API reference for iOSTestingTools.

## Modules

- UnitTesting
- UITesting
- IntegrationTesting
- PerformanceTesting
- DebugTesting
- TestUtilities

## UnitTesting

### TestFramework
- `initialize()`
- `runAllTests()`
- `addTestResult(_:)`
- `getTestStatistics()`

### MockGenerator
- `generateMock(for:)`
- `createMock(with:)`
- `resetMocks()`

### TestDataBuilder
- `createTestUser(...)`
- `createTestProduct(...)`
- `randomString(...)`

### AssertionHelpers
- `assertNotNil(_:)`
- `assertEqual(_:_:)`
- `assertThrows(_:)`

## UITesting

### UITestFramework
- `initialize()`
- `launchApp(...)`
- `findElement(by:)`
- `tap(on:)`
- `typeText(_:into:)`
- `takeScreenshot(name:)`

### ElementFinder
- `findElement(byIdentifier:)`
- `findButton(byText:)`
- `findTextField(byPlaceholder:)`

## IntegrationTesting

### IntegrationFramework
- `initialize(environment:)`
- `runIntegrationTests()`
- `testAPIEndpoint(...)`

## PerformanceTesting

### PerformanceFramework
- `initialize()`
- `measurePerformance(operation:)`
- `runBenchmark(operation:iterations:)`

## TestUtilities

### TestUtilities
- `randomString(length:)`
- `randomEmail(domain:)`
- `wait(for:)`
- `retry(operation:maxAttempts:initialDelay:)`

## For full details, see the inline documentation in each module.