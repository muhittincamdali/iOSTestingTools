// MARK: - UI Test Page Template
// iOSTestingTools Framework
// Created by Muhittin Camdali

import XCTest

// MARK: - Page Object Protocol

/// Protocol for page objects in UI tests
public protocol PageObjectProtocol {
    /// The XCUIApplication instance
    var app: XCUIApplication { get }
    
    /// Verify the page is displayed
    func isDisplayed() -> Bool
    
    /// Wait for page to load
    func waitForLoad(timeout: TimeInterval) -> Bool
}

// MARK: - Base Page Object

/// Base class for page objects
open class BasePage: PageObjectProtocol {
    
    // MARK: - Properties
    
    public let app: XCUIApplication
    public let defaultTimeout: TimeInterval
    
    // MARK: - Initialization
    
    public init(app: XCUIApplication, timeout: TimeInterval = 10.0) {
        self.app = app
        self.defaultTimeout = timeout
    }
    
    // MARK: - Protocol Implementation
    
    open func isDisplayed() -> Bool {
        // Override in subclass
        return true
    }
    
    open func waitForLoad(timeout: TimeInterval) -> Bool {
        return waitForElement(identifyingElement, timeout: timeout)
    }
    
    /// Element that identifies this page
    open var identifyingElement: XCUIElement {
        // Override in subclass
        return app.otherElements.firstMatch
    }
    
    // MARK: - Element Helpers
    
    /// Wait for element to exist
    @discardableResult
    public func waitForElement(
        _ element: XCUIElement,
        timeout: TimeInterval? = nil
    ) -> Bool {
        return element.waitForExistence(timeout: timeout ?? defaultTimeout)
    }
    
    /// Wait for element to disappear
    @discardableResult
    public func waitForElementToDisappear(
        _ element: XCUIElement,
        timeout: TimeInterval? = nil
    ) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout ?? defaultTimeout)
        return result == .completed
    }
    
    /// Tap element safely
    public func tap(_ element: XCUIElement, timeout: TimeInterval? = nil) {
        waitForElement(element, timeout: timeout)
        element.tap()
    }
    
    /// Type text into element
    public func type(
        _ text: String,
        into element: XCUIElement,
        clearFirst: Bool = true
    ) {
        waitForElement(element)
        element.tap()
        
        if clearFirst {
            element.clearText()
        }
        
        element.typeText(text)
    }
    
    /// Swipe on element
    public func swipe(
        _ direction: SwipeDirection,
        on element: XCUIElement? = nil
    ) {
        let target = element ?? app
        
        switch direction {
        case .up:
            target.swipeUp()
        case .down:
            target.swipeDown()
        case .left:
            target.swipeLeft()
        case .right:
            target.swipeRight()
        }
    }
    
    public enum SwipeDirection {
        case up, down, left, right
    }
    
    /// Scroll to element
    public func scrollTo(_ element: XCUIElement, maxScrolls: Int = 10) -> Bool {
        var scrollCount = 0
        
        while !element.isHittable && scrollCount < maxScrolls {
            app.swipeUp()
            scrollCount += 1
        }
        
        return element.isHittable
    }
    
    /// Take screenshot
    @discardableResult
    public func takeScreenshot(name: String) -> XCTAttachment {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        return attachment
    }
}

// MARK: - XCUIElement Extensions

public extension XCUIElement {
    
    /// Clear text from text field
    func clearText() {
        guard let stringValue = value as? String else { return }
        
        tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
    
    /// Check if element contains text
    func containsText(_ text: String) -> Bool {
        return (value as? String)?.contains(text) ?? false
    }
    
    /// Get text value
    var text: String? {
        return value as? String ?? label
    }
}

// MARK: - Login Page Example

/// Example login page object
public final class LoginPage: BasePage {
    
    // MARK: - Elements
    
    private var emailField: XCUIElement {
        app.textFields["emailTextField"]
    }
    
    private var passwordField: XCUIElement {
        app.secureTextFields["passwordTextField"]
    }
    
    private var loginButton: XCUIElement {
        app.buttons["loginButton"]
    }
    
    private var errorLabel: XCUIElement {
        app.staticTexts["errorLabel"]
    }
    
    private var forgotPasswordButton: XCUIElement {
        app.buttons["forgotPasswordButton"]
    }
    
    // MARK: - Identifying Element
    
    public override var identifyingElement: XCUIElement {
        return loginButton
    }
    
    // MARK: - Actions
    
    /// Enter email
    @discardableResult
    public func enterEmail(_ email: String) -> Self {
        type(email, into: emailField)
        return self
    }
    
    /// Enter password
    @discardableResult
    public func enterPassword(_ password: String) -> Self {
        type(password, into: passwordField)
        return self
    }
    
    /// Tap login button
    @discardableResult
    public func tapLogin() -> Self {
        tap(loginButton)
        return self
    }
    
    /// Perform login
    @discardableResult
    public func login(email: String, password: String) -> Self {
        enterEmail(email)
        enterPassword(password)
        tapLogin()
        return self
    }
    
    /// Tap forgot password
    public func tapForgotPassword() -> ForgotPasswordPage {
        tap(forgotPasswordButton)
        return ForgotPasswordPage(app: app)
    }
    
    // MARK: - Assertions
    
    /// Check if error is displayed
    public var isErrorDisplayed: Bool {
        return errorLabel.exists && !errorLabel.label.isEmpty
    }
    
    /// Get error message
    public var errorMessage: String? {
        guard isErrorDisplayed else { return nil }
        return errorLabel.label
    }
    
    /// Check if login button is enabled
    public var isLoginButtonEnabled: Bool {
        return loginButton.isEnabled
    }
}

// MARK: - Forgot Password Page Example

public final class ForgotPasswordPage: BasePage {
    
    private var emailField: XCUIElement {
        app.textFields["resetEmailTextField"]
    }
    
    private var submitButton: XCUIElement {
        app.buttons["submitButton"]
    }
    
    public override var identifyingElement: XCUIElement {
        return submitButton
    }
    
    @discardableResult
    public func enterEmail(_ email: String) -> Self {
        type(email, into: emailField)
        return self
    }
    
    @discardableResult
    public func tapSubmit() -> Self {
        tap(submitButton)
        return self
    }
}

// MARK: - Home Page Example

public final class HomePage: BasePage {
    
    private var welcomeLabel: XCUIElement {
        app.staticTexts["welcomeLabel"]
    }
    
    private var profileButton: XCUIElement {
        app.buttons["profileButton"]
    }
    
    private var settingsButton: XCUIElement {
        app.buttons["settingsButton"]
    }
    
    public override var identifyingElement: XCUIElement {
        return welcomeLabel
    }
    
    public var welcomeMessage: String? {
        return welcomeLabel.label
    }
    
    public func tapProfile() -> ProfilePage {
        tap(profileButton)
        return ProfilePage(app: app)
    }
    
    public func tapSettings() -> SettingsPage {
        tap(settingsButton)
        return SettingsPage(app: app)
    }
}

// MARK: - Profile Page Example

public final class ProfilePage: BasePage {
    
    private var nameLabel: XCUIElement {
        app.staticTexts["nameLabel"]
    }
    
    public override var identifyingElement: XCUIElement {
        return nameLabel
    }
    
    public var displayedName: String? {
        return nameLabel.label
    }
}

// MARK: - Settings Page Example

public final class SettingsPage: BasePage {
    
    private var logoutButton: XCUIElement {
        app.buttons["logoutButton"]
    }
    
    public override var identifyingElement: XCUIElement {
        return logoutButton
    }
    
    public func tapLogout() -> LoginPage {
        tap(logoutButton)
        return LoginPage(app: app)
    }
}

// MARK: - Usage Example

/*
 final class LoginUITests: XCTestCase {
     
     var app: XCUIApplication!
     var loginPage: LoginPage!
     
     override func setUp() {
         super.setUp()
         
         app = XCUIApplication()
         app.launch()
         
         loginPage = LoginPage(app: app)
     }
     
     func testSuccessfulLogin() {
         // Given
         let email = "test@example.com"
         let password = "password123"
         
         // When
         loginPage
             .enterEmail(email)
             .enterPassword(password)
             .tapLogin()
         
         // Then
         let homePage = HomePage(app: app)
         XCTAssertTrue(homePage.waitForLoad(timeout: 10))
         XCTAssertNotNil(homePage.welcomeMessage)
     }
     
     func testInvalidLogin() {
         // Given
         let email = "invalid@example.com"
         let password = "wrong"
         
         // When
         loginPage.login(email: email, password: password)
         
         // Then
         XCTAssertTrue(loginPage.isErrorDisplayed)
         XCTAssertEqual(loginPage.errorMessage, "Invalid credentials")
     }
 }
 */
