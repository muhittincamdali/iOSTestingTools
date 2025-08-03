# UI Testing Guide

This guide explains how to write and run UI tests using iOSTestingTools.

## Writing UI Tests

1. Import the framework:
   ```swift
   import iOSTestingTools
   ```
2. Create a test class inheriting from `XCTestCase`.
3. Use the provided UI test helpers and element finders.

## Example

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
        let emailField = app.textFields["email"]
        let passwordField = app.secureTextFields["password"]
        let loginButton = app.buttons["login"]

        emailField.tap()
        emailField.typeText("test@example.com")
        passwordField.tap()
        passwordField.typeText("password123")
        loginButton.tap()

        let welcomeLabel = app.staticTexts["Welcome"]
        XCTAssertTrue(welcomeLabel.waitForExistence(timeout: 5))
    }
}
```

## Element Finder

Use `ElementFinder` to locate UI elements by identifier, text, or placeholder.

```swift
let emailField = ElementFinder.shared.findTextField(byPlaceholder: "Email")
```

## Taking Screenshots

Use `UITestFramework` to take screenshots during tests:

```swift
UITestFramework.shared.takeScreenshot(name: "LoginScreen")
```

## Best Practices

- Use accessibility identifiers for all UI elements.
- Keep UI tests fast and reliable.
- Test both positive and negative scenarios.
- Use screenshots for debugging UI failures.