import Foundation
import XCTest
import UIKit

// MARK: - UI Test Framework
public class UITestFramework {
    
    // MARK: - Singleton
    public static let shared = UITestFramework()
    
    // MARK: - Private Properties
    private var testApp: XCUIApplication?
    private var elementCache: [String: XCUIElement] = [:]
    private var screenshotManager: ScreenshotManager?
    
    // MARK: - Initialization
    private init() {
        screenshotManager = ScreenshotManager()
    }
    
    // MARK: - Public Methods
    
    /// Initialize the UI test framework
    public static func initialize() {
        shared.setupTestEnvironment()
    }
    
    /// Launch the test app
    public func launchApp(bundleIdentifier: String? = nil, arguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        
        if let bundleId = bundleIdentifier {
            app.bundleIdentifier = bundleId
        }
        
        app.launchArguments = arguments
        app.launch()
        
        testApp = app
        return app
    }
    
    /// Find element by accessibility identifier
    public func findElement(by identifier: String) -> XCUIElement? {
        guard let app = testApp else { return nil }
        
        if let cached = elementCache[identifier] {
            return cached
        }
        
        let element = app.descendants(matching: .any).matching(identifier: identifier).firstMatch
        elementCache[identifier] = element
        return element
    }
    
    /// Find element by text
    public func findElement(byText text: String) -> XCUIElement? {
        guard let app = testApp else { return nil }
        return app.staticTexts[text].firstMatch
    }
    
    /// Find button by text
    public func findButton(byText text: String) -> XCUIElement? {
        guard let app = testApp else { return nil }
        return app.buttons[text].firstMatch
    }
    
    /// Find text field by placeholder
    public func findTextField(byPlaceholder placeholder: String) -> XCUIElement? {
        guard let app = testApp else { return nil }
        return app.textFields[placeholder].firstMatch
    }
    
    /// Tap on element
    public func tap(on element: XCUIElement) {
        element.tap()
    }
    
    /// Type text into element
    public func typeText(_ text: String, into element: XCUIElement) {
        element.tap()
        element.typeText(text)
    }
    
    /// Clear text from element
    public func clearText(from element: XCUIElement) {
        element.tap()
        element.doubleTap()
        element.typeText("")
    }
    
    /// Swipe on element
    public func swipe(on element: XCUIElement, direction: SwipeDirection) {
        switch direction {
        case .up:
            element.swipeUp()
        case .down:
            element.swipeDown()
        case .left:
            element.swipeLeft()
        case .right:
            element.swipeRight()
        }
    }
    
    /// Wait for element to appear
    public func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 5.0) -> Bool {
        return element.waitForExistence(timeout: timeout)
    }
    
    /// Wait for element to disappear
    public func waitForElementToDisappear(_ element: XCUIElement, timeout: TimeInterval = 5.0) -> Bool {
        let expectation = XCTestExpectation(description: "Element should disappear")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if !element.exists {
                expectation.fulfill()
            }
        }
        
        return XCTWaiter.wait(for: [expectation], timeout: timeout) == .completed
    }
    
    /// Take screenshot
    public func takeScreenshot(name: String) {
        screenshotManager?.takeScreenshot(name: name)
    }
    
    /// Verify element exists
    public func assertElementExists(_ element: XCUIElement, message: String = "Element should exist") {
        XCTAssertTrue(element.exists, message)
    }
    
    /// Verify element does not exist
    public func assertElementDoesNotExist(_ element: XCUIElement, message: String = "Element should not exist") {
        XCTAssertFalse(element.exists, message)
    }
    
    /// Verify element is enabled
    public func assertElementIsEnabled(_ element: XCUIElement, message: String = "Element should be enabled") {
        XCTAssertTrue(element.isEnabled, message)
    }
    
    /// Verify element is disabled
    public func assertElementIsDisabled(_ element: XCUIElement, message: String = "Element should be disabled") {
        XCTAssertFalse(element.isEnabled, message)
    }
    
    /// Verify element text
    public func assertElementText(_ element: XCUIElement, expectedText: String, message: String = "Element should have expected text") {
        XCTAssertEqual(element.label, expectedText, message)
    }
    
    /// Verify element contains text
    public func assertElementContainsText(_ element: XCUIElement, expectedText: String, message: String = "Element should contain expected text") {
        XCTAssertTrue(element.label.contains(expectedText), message)
    }
    
    // MARK: - Private Methods
    
    private func setupTestEnvironment() {
        // Setup test environment
        print("✅ UITestFramework initialized successfully")
    }
}

// MARK: - Swipe Direction
public enum SwipeDirection {
    case up
    case down
    case left
    case right
}

// MARK: - Screenshot Manager
public class ScreenshotManager {
    
    private var screenshotCount = 0
    
    public func takeScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "\(name)_\(screenshotCount)"
        attachment.lifetime = .keepAlways
        XCTContext.runActivity(named: "Screenshot: \(name)") { activity in
            activity.add(attachment)
        }
        screenshotCount += 1
    }
} 