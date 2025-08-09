# Getting Started with iOSTestingTools

<!-- TOC START -->
## Table of Contents
- [Getting Started with iOSTestingTools](#getting-started-with-iostestingtools)
- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
  - [CocoaPods](#cocoapods)
  - [Carthage](#carthage)
- [Quick Start](#quick-start)
- [Example](#example)
- [Documentation](#documentation)
- [Support](#support)
<!-- TOC END -->


Welcome to iOSTestingTools! This guide will help you set up and start using the framework for your iOS projects.

## Installation

### Swift Package Manager

Add the following to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOSTestingTools.git", from: "1.0.0")
]
```

Or in Xcode:
1. File → Add Packages
2. Enter: `https://github.com/muhittincamdali/iOSTestingTools.git`
3. Select version: `1.0.0`

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'iOSTestingTools', '~> 1.0.0'
```

### Carthage

Add to your `Cartfile`:

```
github "muhittincamdali/iOSTestingTools" ~> 1.0.0
```

## Quick Start

1. Import the framework:
   ```swift
   import iOSTestingTools
   ```
2. Initialize the testing framework:
   ```swift
   TestFramework.initialize()
   ```
3. Start writing your tests using the provided utilities and helpers.

## Example

```swift
import iOSTestingTools

class UserServiceTests: XCTestCase {
    func testFetchUser() async throws {
        let userService = UserService()
        let user = try await userService.fetchUser(id: "1")
        XCTAssertEqual(user.name, "John Doe")
    }
}
```

## Documentation

- [API Reference](API.md)
- [Unit Testing Guide](UnitTestingGuide.md)
- [UI Testing Guide](UITestingGuide.md)
- [Integration Testing Guide](IntegrationTestingGuide.md)
- [Performance Testing Guide](PerformanceTestingGuide.md)
- [Mock Generation Guide](MockGenerationGuide.md)

## Support

- [GitHub Issues](https://github.com/muhittincamdali/iOSTestingTools/issues)
- [Discussions](https://github.com/muhittincamdali/iOSTestingTools/discussions)