import Foundation
import XCTest
import UIKit

// MARK: - Element Finder
public class ElementFinder {
    
    // MARK: - Singleton
    public static let shared = ElementFinder()
    
    // MARK: - Private Properties
    private var app: XCUIApplication?
    private var elementCache: [String: XCUIElement] = [:]
    private var searchStrategies: [String: SearchStrategy] = [:]
    
    // MARK: - Initialization
    private init() {
        setupDefaultStrategies()
    }
    
    // MARK: - Public Methods
    
    /// Set the app instance
    public func setApp(_ app: XCUIApplication) {
        self.app = app
        clearCache()
    }
    
    /// Find element by accessibility identifier
    public func findElement(byIdentifier identifier: String) -> XCUIElement? {
        guard let app = app else { return nil }
        
        if let cached = elementCache[identifier] {
            return cached
        }
        
        let element = app.descendants(matching: .any).matching(identifier: identifier).firstMatch
        elementCache[identifier] = element
        return element
    }
    
    /// Find element by accessibility label
    public func findElement(byLabel label: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.descendants(matching: .any).matching(NSPredicate(format: "label == %@", label)).firstMatch
    }
    
    /// Find element by text
    public func findElement(byText text: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.staticTexts[text].firstMatch
    }
    
    /// Find element by placeholder text
    public func findElement(byPlaceholder placeholder: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.textFields[placeholder].firstMatch
    }
    
    /// Find button by text
    public func findButton(byText text: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.buttons[text].firstMatch
    }
    
    /// Find text field by placeholder
    public func findTextField(byPlaceholder placeholder: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.textFields[placeholder].firstMatch
    }
    
    /// Find secure text field by placeholder
    public func findSecureTextField(byPlaceholder placeholder: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.secureTextFields[placeholder].firstMatch
    }
    
    /// Find image by accessibility identifier
    public func findImage(byIdentifier identifier: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.images[identifier].firstMatch
    }
    
    /// Find table view by accessibility identifier
    public func findTableView(byIdentifier identifier: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.tables[identifier].firstMatch
    }
    
    /// Find collection view by accessibility identifier
    public func findCollectionView(byIdentifier identifier: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.collectionViews[identifier].firstMatch
    }
    
    /// Find scroll view by accessibility identifier
    public func findScrollView(byIdentifier identifier: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.scrollViews[identifier].firstMatch
    }
    
    /// Find web view by accessibility identifier
    public func findWebView(byIdentifier identifier: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.webViews[identifier].firstMatch
    }
    
    /// Find element by predicate
    public func findElement(byPredicate predicate: NSPredicate) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.descendants(matching: .any).matching(predicate).firstMatch
    }
    
    /// Find element by type and identifier
    public func findElement(ofType type: XCUIElement.ElementType, withIdentifier identifier: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.descendants(matching: type).matching(identifier: identifier).firstMatch
    }
    
    /// Find all elements by accessibility identifier
    public func findAllElements(byIdentifier identifier: String) -> XCUIElementQuery {
        guard let app = app else { return XCUIElementQuery() }
        return app.descendants(matching: .any).matching(identifier: identifier)
    }
    
    /// Find all elements by text
    public func findAllElements(byText text: String) -> XCUIElementQuery {
        guard let app = app else { return XCUIElementQuery() }
        return app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", text))
    }
    
    /// Find element with custom search strategy
    public func findElement(using strategy: SearchStrategy) -> XCUIElement? {
        guard let app = app else { return nil }
        
        switch strategy {
        case .identifier(let identifier):
            return findElement(byIdentifier: identifier)
        case .label(let label):
            return findElement(byLabel: label)
        case .text(let text):
            return findElement(byText: text)
        case .placeholder(let placeholder):
            return findElement(byPlaceholder: placeholder)
        case .predicate(let predicate):
            return findElement(byPredicate: predicate)
        case .typeAndIdentifier(let type, let identifier):
            return findElement(ofType: type, withIdentifier: identifier)
        case .custom(let customStrategy):
            return customStrategy(app)
        }
    }
    
    /// Wait for element to appear
    public func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 5.0) -> Bool {
        return element.waitForExistence(timeout: timeout)
    }
    
    /// Wait for element with strategy
    public func waitForElement(using strategy: SearchStrategy, timeout: TimeInterval = 5.0) -> XCUIElement? {
        let startTime = Date()
        
        while Date().timeIntervalSince(startTime) < timeout {
            if let element = findElement(using: strategy), element.exists {
                return element
            }
            Thread.sleep(forTimeInterval: 0.1)
        }
        
        return nil
    }
    
    /// Clear element cache
    public func clearCache() {
        elementCache.removeAll()
    }
    
    /// Register custom search strategy
    public func registerStrategy(name: String, strategy: @escaping (XCUIApplication) -> XCUIElement?) {
        searchStrategies[name] = .custom(strategy)
    }
    
    // MARK: - Private Methods
    
    private func setupDefaultStrategies() {
        // Setup default search strategies
        searchStrategies["loginButton"] = .text("Login")
        searchStrategies["emailField"] = .placeholder("Email")
        searchStrategies["passwordField"] = .placeholder("Password")
        searchStrategies["submitButton"] = .text("Submit")
        searchStrategies["cancelButton"] = .text("Cancel")
    }
}

// MARK: - Search Strategy
public enum SearchStrategy {
    case identifier(String)
    case label(String)
    case text(String)
    case placeholder(String)
    case predicate(NSPredicate)
    case typeAndIdentifier(XCUIElement.ElementType, String)
    case custom((XCUIApplication) -> XCUIElement?)
}

// MARK: - Element Finder Error
public enum ElementFinderError: LocalizedError {
    case appNotSet
    case elementNotFound(String)
    case timeout(String)
    case invalidStrategy
    
    public var errorDescription: String? {
        switch self {
        case .appNotSet:
            return "App not set in ElementFinder"
        case .elementNotFound(let identifier):
            return "Element not found: \(identifier)"
        case .timeout(let message):
            return "Timeout: \(message)"
        case .invalidStrategy:
            return "Invalid search strategy"
        }
    }
}

// MARK: - Element Finder Extensions
extension ElementFinder {
    
    /// Find element by partial text match
    public func findElement(byPartialText text: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", text)).firstMatch
    }
    
    /// Find element by exact text match
    public func findElement(byExactText text: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.staticTexts.matching(NSPredicate(format: "label == %@", text)).firstMatch
    }
    
    /// Find element by case insensitive text match
    public func findElement(byCaseInsensitiveText text: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] %@", text)).firstMatch
    }
    
    /// Find element by accessibility hint
    public func findElement(byHint hint: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.descendants(matching: .any).matching(NSPredicate(format: "hint == %@", hint)).firstMatch
    }
    
    /// Find element by accessibility value
    public func findElement(byValue value: String) -> XCUIElement? {
        guard let app = app else { return nil }
        return app.descendants(matching: .any).matching(NSPredicate(format: "value == %@", value)).firstMatch
    }
} 