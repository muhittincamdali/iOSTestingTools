# 🧪 iOS Testing Tools

<div align="center">

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![iOS 15.0+](https://img.shields.io/badge/iOS-15.0+-000000?style=for-the-badge&logo=ios&logoColor=white)](https://developer.apple.com/ios/)
[![macOS 12.0+](https://img.shields.io/badge/macOS-12.0+-007AFF?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/macos/)
[![SPM Compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)

**A comprehensive testing toolkit for iOS developers**

Modern, modular, and production-ready testing utilities for unit tests, UI tests, integration tests, and performance testing.

[Features](#-features) • [Installation](#-installation) • [Quick Start](#-quick-start) • [Modules](#-modules) • [Documentation](#-documentation)

</div>

---

## ✨ Features

- **🎯 Modular Architecture** — Pick only the modules you need
- **📱 Multi-Platform** — iOS, macOS, watchOS, and tvOS support
- **⚡ Modern Swift** — Built with Swift 5.9+ and async/await
- **🔧 Zero Configuration** — Works out of the box with sensible defaults
- **📊 Performance Metrics** — Built-in performance measurement utilities
- **🧩 XCTest Integration** — Seamlessly extends XCTest framework
- **🔄 CI/CD Ready** — GitHub Actions, Xcode Cloud, Bitrise compatible

---

## 📦 Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOSTestingTools.git", from: "1.0.0")
]
```

Then add the modules you need:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "iOSTestingTools", package: "iOSTestingTools"),
        // Or individual modules:
        .product(name: "UnitTesting", package: "iOSTestingTools"),
        .product(name: "UITesting", package: "iOSTestingTools"),
        .product(name: "PerformanceTesting", package: "iOSTestingTools"),
    ]
)
```

### Xcode

1. Go to **File → Add Package Dependencies**
2. Enter: `https://github.com/muhittincamdali/iOSTestingTools.git`
3. Select the modules you need

---

## 🚀 Quick Start

### Basic Setup

```swift
import iOSTestingTools

// Initialize with default configuration
let testingTools = iOSTestingTools()
testingTools.configure()

// Or with custom configuration
let config = Configuration()
config.debugMode = true
config.logLevel = .debug

let tools = iOSTestingTools(configuration: config)
tools.configure()
```

### Unit Testing Example

```swift
import XCTest
import UnitTesting

final class UserServiceTests: XCTestCase {
    
    var sut: UserService!
    var mockRepository: MockUserRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        sut = UserService(repository: mockRepository)
    }
    
    func testFetchUser_ReturnsCorrectUser() async throws {
        // Given
        let expectedUser = User(id: "123", name: "John")
        mockRepository.stubbedUser = expectedUser
        
        // When
        let result = try await sut.fetchUser(id: "123")
        
        // Then
        XCTAssertEqual(result, expectedUser)
        XCTAssertTrue(mockRepository.fetchUserCalled)
    }
}
```

### UI Testing Example

```swift
import XCTest
import UITesting

final class LoginUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }
    
    func testLoginFlow_WithValidCredentials_NavigatesToHome() {
        // Enter credentials
        app.textFields["emailField"].tap()
        app.textFields["emailField"].typeText("user@example.com")
        
        app.secureTextFields["passwordField"].tap()
        app.secureTextFields["passwordField"].typeText("password123")
        
        // Tap login button
        app.buttons["loginButton"].tap()
        
        // Verify navigation to home
        XCTAssertTrue(app.navigationBars["Home"].waitForExistence(timeout: 5))
    }
}
```

### Performance Testing Example

```swift
import XCTest
import PerformanceTesting

final class DataProcessingPerformanceTests: XCTestCase {
    
    func testLargeDataProcessing_CompletesWithinThreshold() {
        let data = generateLargeDataSet(count: 10_000)
        
        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            _ = DataProcessor.process(data)
        }
    }
    
    func testImageLoading_MemoryEfficient() {
        let options = XCTMeasureOptions()
        options.iterationCount = 5
        
        measure(metrics: [XCTMemoryMetric()], options: options) {
            let imageLoader = ImageLoader()
            _ = imageLoader.loadImages(count: 100)
        }
    }
}
```

---

## 📚 Modules

### Core Module: `iOSTestingTools`
The main entry point that includes all submodules.

### `UnitTesting`
Utilities for unit testing including mocking helpers, assertion extensions, and test doubles.

```swift
import UnitTesting

// Create mock objects easily
let mockService = Mock<NetworkService>()
mockService.when(\.fetchData).thenReturn(mockData)

// Enhanced assertions
XCTAssertThrowsAsync(try await service.riskyOperation())
```

### `UITesting`
Tools for UI testing with XCUITest, including screen object patterns and accessibility helpers.

```swift
import UITesting

// Screen Object Pattern
let loginScreen = LoginScreen(app)
loginScreen.enterEmail("test@example.com")
loginScreen.enterPassword("password")
loginScreen.tapLogin()
```

### `IntegrationTesting`
Helpers for integration testing with network stubs, database mocks, and end-to-end scenarios.

```swift
import IntegrationTesting

// Stub network responses
NetworkStub.stub(endpoint: "/api/users") {
    .success(jsonFile: "users_response.json")
}
```

### `PerformanceTesting`
Performance measurement and benchmarking utilities.

```swift
import PerformanceTesting

// Custom performance metrics
let benchmark = Benchmark("Data Processing")
benchmark.measure {
    processLargeDataSet()
}
print(benchmark.report())
```

### `DebugTesting`
Debug utilities for development and testing.

### `TestUtilities`
Common utilities shared across all testing modules.

---

## 🏗️ Architecture

```
iOSTestingTools/
├── Sources/
│   ├── iOSTestingTools.swift      # Main entry point
│   ├── Core/                       # Core framework
│   ├── UnitTesting/               # Unit test utilities
│   ├── UITesting/                 # UI test utilities
│   ├── IntegrationTesting/        # Integration test helpers
│   ├── PerformanceTesting/        # Performance benchmarks
│   ├── DebugTesting/              # Debug utilities
│   └── TestUtilities/             # Shared utilities
├── Tests/
│   └── iOSTestingToolsTests/      # Framework tests
├── Examples/
│   ├── BasicExamples/             # Basic usage examples
│   ├── UITestingExamples/         # UI testing examples
│   └── PerformanceTestingExamples/# Performance examples
└── Documentation/
```

---

## 📋 Requirements

| Platform | Minimum Version |
|----------|-----------------|
| iOS      | 15.0+           |
| macOS    | 12.0+           |
| watchOS  | 8.0+            |
| tvOS     | 15.0+           |
| Swift    | 5.9+            |
| Xcode    | 15.0+           |

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Apple's XCTest framework
- The Swift community for inspiration and feedback

---

<div align="center">

**Made with ❤️ for iOS developers**

⭐ Star this repository if you find it helpful!

</div>
