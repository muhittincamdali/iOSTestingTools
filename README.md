# iOS Testing Tools

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-red.svg)](CHANGELOG.md)

A comprehensive collection of testing tools and utilities for iOS development, providing easy-to-use testing frameworks, mocks, and helpers for unit tests, UI tests, and integration tests.

## 📋 Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Documentation](#documentation)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

### 🧪 Unit Testing Tools
- **TestFramework**: Core testing framework with assertions
- **MockGenerator**: Automatic mock generation
- **TestDataBuilder**: Test data creation utilities
- **AssertionHelpers**: Custom assertion methods

### 🎯 UI Testing Tools
- **UITestFramework**: UI testing framework
- **ElementFinder**: UI element locators
- **GestureSimulator**: Touch and gesture simulation
- **ScreenshotHelper**: Screenshot capture utilities

### 🔄 Integration Testing Tools
- **IntegrationFramework**: Integration test framework
- **APITestClient**: API testing utilities
- **DatabaseTester**: Database testing helpers
- **NetworkSimulator**: Network condition simulation

### 📊 Performance Testing Tools
- **PerformanceFramework**: Performance testing framework
- **MemoryProfiler**: Memory usage monitoring
- **CPUProfiler**: CPU usage monitoring
- **BatteryTester**: Battery usage testing

### 🐛 Debug Testing Tools
- **DebugFramework**: Debug testing utilities
- **CrashReporter**: Crash detection and reporting
- **LogAnalyzer**: Log analysis tools
- **ErrorSimulator**: Error condition simulation

### 🔧 Test Utilities
- **TestUtilities**: General testing utilities
- **TestConfiguration**: Test configuration management
- **TestReporting**: Test result reporting
- **TestRunner**: Test execution engine

## 📱 Requirements

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+
- XCTest framework

## 🚀 Installation

### Swift Package Manager

Add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/iOSTestingTools.git", from: "1.0.0")
]
```

Or add it directly in Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/your-username/iOSTestingTools.git`
3. Select version: `1.0.0`

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'iOSTestingTools', '~> 1.0.0'
```

### Carthage

Add to your `Cartfile`:

```
github "your-username/iOSTestingTools" ~> 1.0.0
```

## ⚡ Quick Start

### 1. Setup Testing Framework

```swift
import iOSTestingTools

// Initialize testing framework
TestingFramework.initialize()
```

### 2. Unit Testing

```swift
import iOSTestingTools

class UserServiceTests: XCTestCase {
    
    var userService: UserService!
    var mockUserRepository: MockUserRepository!
    
    override func setUp() {
        super.setUp()
        mockUserRepository = MockUserRepository()
        userService = UserService(repository: mockUserRepository)
    }
    
    func testFetchUserSuccess() async throws {
        // Given
        let expectedUser = User(id: "1", name: "John Doe", email: "john@example.com")
        mockUserRepository.fetchUserResult = .success(expectedUser)
        
        // When
        let user = try await userService.fetchUser(id: "1")
        
        // Then
        XCTAssertEqual(user.name, expectedUser.name)
        XCTAssertEqual(user.email, expectedUser.email)
        XCTAssertTrue(mockUserRepository.fetchUserCalled)
    }
    
    func testFetchUserFailure() async {
        // Given
        let expectedError = NetworkError.timeout
        mockUserRepository.fetchUserResult = .failure(expectedError)
        
        // When & Then
        do {
            _ = try await userService.fetchUser(id: "1")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, expectedError)
        }
    }
}
```

### 3. UI Testing

```swift
import iOSTestingTools

class LoginUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    func testLoginFlow() {
        // Given
        let emailTextField = app.textFields["email"]
        let passwordTextField = app.secureTextFields["password"]
        let loginButton = app.buttons["login"]
        
        // When
        emailTextField.tap()
        emailTextField.typeText("test@example.com")
        
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        
        loginButton.tap()
        
        // Then
        let welcomeLabel = app.staticTexts["Welcome"]
        XCTAssertTrue(welcomeLabel.waitForExistence(timeout: 5))
    }
    
    func testLoginValidation() {
        // Given
        let loginButton = app.buttons["login"]
        
        // When
        loginButton.tap()
        
        // Then
        let errorLabel = app.staticTexts["Please enter valid email and password"]
        XCTAssertTrue(errorLabel.waitForExistence(timeout: 2))
    }
}
```

### 4. Integration Testing

```swift
import iOSTestingTools

class APIIntegrationTests: XCTestCase {
    
    var apiClient: APITestClient!
    
    override func setUp() {
        super.setUp()
        apiClient = APITestClient(baseURL: "https://api.example.com")
    }
    
    func testUserAPI() async throws {
        // Given
        let userData = ["name": "John Doe", "email": "john@example.com"]
        
        // When
        let response = try await apiClient.post("/users", data: userData)
        
        // Then
        XCTAssertEqual(response.statusCode, 201)
        XCTAssertNotNil(response.data["id"])
    }
    
    func testDatabaseIntegration() async throws {
        // Given
        let databaseTester = DatabaseTester()
        
        // When
        try await databaseTester.setupTestData()
        let users = try await databaseTester.query("SELECT * FROM users")
        
        // Then
        XCTAssertGreaterThan(users.count, 0)
    }
}
```

### 5. Performance Testing

```swift
import iOSTestingTools

class PerformanceTests: XCTestCase {
    
    func testUserListPerformance() {
        measure {
            // Measure the performance of user list loading
            let expectation = XCTestExpectation(description: "User list loaded")
            
            Task {
                let users = try await UserService.shared.fetchUsers()
                XCTAssertGreaterThan(users.count, 0)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 10.0)
        }
    }
    
    func testMemoryUsage() {
        let memoryProfiler = MemoryProfiler()
        
        // Start memory profiling
        memoryProfiler.startProfiling()
        
        // Perform memory-intensive operation
        for _ in 0..<1000 {
            let _ = User(id: UUID().uuidString, name: "Test", email: "test@example.com")
        }
        
        // Stop profiling and get results
        let memoryUsage = memoryProfiler.stopProfiling()
        XCTAssertLessThan(memoryUsage.peakMemory, 100 * 1024 * 1024) // 100MB
    }
}
```

### 6. Mock Generation

```swift
import iOSTestingTools

// Generate mock for UserRepository protocol
@Mock
protocol UserRepository {
    func fetchUser(id: String) async throws -> User
    func saveUser(_ user: User) async throws
    func deleteUser(id: String) async throws
}

// Use generated mock in tests
class UserServiceTests: XCTestCase {
    
    @Mocked var userRepository: UserRepository!
    var userService: UserService!
    
    override func setUp() {
        super.setUp()
        userService = UserService(repository: userRepository)
    }
    
    func testFetchUser() async throws {
        // Given
        let expectedUser = User(id: "1", name: "John", email: "john@example.com")
        userRepository.fetchUserResult = .success(expectedUser)
        
        // When
        let user = try await userService.fetchUser(id: "1")
        
        // Then
        XCTAssertEqual(user.name, expectedUser.name)
        XCTAssertTrue(userRepository.fetchUserCalled)
    }
}
```

## 📚 Documentation

### [Getting Started Guide](Documentation/GettingStarted.md)
Complete setup and configuration guide.

### [Unit Testing Guide](Documentation/UnitTestingGuide.md)
Comprehensive unit testing implementation.

### [UI Testing Guide](Documentation/UITestingGuide.md)
UI testing and automation.

### [Integration Testing Guide](Documentation/IntegrationTestingGuide.md)
Integration testing strategies.

### [Performance Testing Guide](Documentation/PerformanceTestingGuide.md)
Performance testing and monitoring.

### [Mock Generation Guide](Documentation/MockGenerationGuide.md)
Mock generation and usage.

### [API Reference](Documentation/API.md)
Complete API documentation.

## 🎯 Examples

### [Basic Example](Examples/BasicExample/)
Simple testing implementation example.

### [Advanced Example](Examples/AdvancedExample/)
Complex testing scenarios implementation.

### [Custom Example](Examples/CustomExample/)
Custom testing implementation.

## 🛠️ Architecture

```
iOSTestingTools/
├── Sources/
│   ├── UnitTesting/
│   │   ├── TestFramework.swift
│   │   ├── MockGenerator.swift
│   │   ├── TestDataBuilder.swift
│   │   └── AssertionHelpers.swift
│   ├── UITesting/
│   │   ├── UITestFramework.swift
│   │   ├── ElementFinder.swift
│   │   ├── GestureSimulator.swift
│   │   └── ScreenshotHelper.swift
│   ├── IntegrationTesting/
│   │   ├── IntegrationFramework.swift
│   │   ├── APITestClient.swift
│   │   ├── DatabaseTester.swift
│   │   └── NetworkSimulator.swift
│   ├── PerformanceTesting/
│   │   ├── PerformanceFramework.swift
│   │   ├── MemoryProfiler.swift
│   │   ├── CPUProfiler.swift
│   │   └── BatteryTester.swift
│   ├── DebugTesting/
│   │   ├── DebugFramework.swift
│   │   ├── CrashReporter.swift
│   │   ├── LogAnalyzer.swift
│   │   └── ErrorSimulator.swift
│   ├── TestUtilities/
│   │   ├── TestUtilities.swift
│   │   ├── TestConfiguration.swift
│   │   ├── TestReporting.swift
│   │   └── TestRunner.swift
│   └── iOSTestingTools/
│       └── iOSTestingTools.swift
├── Documentation/
├── Examples/
├── Tests/
└── Resources/
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

### Code Style

- Follow Swift API Design Guidelines
- Use meaningful names
- Add documentation comments
- Write comprehensive tests

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**⭐ Star this repository if it helped you!**

## 📊 Project Statistics

<div align="center">

[![GitHub stars](https://img.shields.io/github/stars/muhittincamdali/iOSTestingTools?style=social)](https://github.com/muhittincamdali/iOSTestingTools/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/muhittincamdali/iOSTestingTools?style=social)](https://github.com/muhittincamdali/iOSTestingTools/network)
[![GitHub issues](https://img.shields.io/github/issues/muhittincamdali/iOSTestingTools)](https://github.com/muhittincamdali/iOSTestingTools/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/muhittincamdali/iOSTestingTools)](https://github.com/muhittincamdali/iOSTestingTools/pulls)

</div>

## 🌟 Stargazers

[![Stargazers repo roster for @muhittincamdali/iOSTestingTools](https://reporoster.com/stars/muhittincamdali/iOSTestingTools)](https://github.com/muhittincamdali/iOSTestingTools/stargazers)

## 🙏 Acknowledgments

- [XCTest](https://developer.apple.com/documentation/xctest) for the testing framework
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) for the modern UI framework
- The iOS testing community for inspiration and feedback

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/your-username/iOSTestingTools/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/iOSTestingTools/discussions)
- **Documentation**: [Documentation](Documentation/)
- **Examples**: [Examples](Examples/)

---

**Made with ❤️ for the iOS testing community** 