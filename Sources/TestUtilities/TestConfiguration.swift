import Foundation

// MARK: - Test Configuration
public class TestConfiguration {
    
    // MARK: - Singleton
    public static let shared = TestConfiguration()
    
    // MARK: - Properties
    public var environment: TestEnvironment = .development
    public var timeout: TimeInterval = 30.0
    public var retryCount: Int = 3
    public var logLevel: LogLevel = .info
    public var enableLogging: Bool = true
    public var enableScreenshots: Bool = true
    public var enablePerformanceMonitoring: Bool = true
    public var enableNetworkMonitoring: Bool = true
    
    // MARK: - Private Properties
    private var customSettings: [String: Any] = [:]
    
    // MARK: - Initialization
    private init() {
        loadDefaultConfiguration()
    }
    
    // MARK: - Public Methods
    
    /// Load configuration from file
    public func loadConfiguration(from file: String) throws {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
            throw TestConfigurationError.fileNotFound(file)
        }
        
        let data = try Data(contentsOf: url)
        let config = try JSONDecoder().decode(ConfigurationData.self, from: data)
        
        applyConfiguration(config)
    }
    
    /// Save configuration to file
    public func saveConfiguration(to file: String) throws {
        let config = ConfigurationData(
            environment: environment,
            timeout: timeout,
            retryCount: retryCount,
            logLevel: logLevel,
            enableLogging: enableLogging,
            enableScreenshots: enableScreenshots,
            enablePerformanceMonitoring: enablePerformanceMonitoring,
            enableNetworkMonitoring: enableNetworkMonitoring
        )
        
        let data = try JSONEncoder().encode(config)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(file)
        try data.write(to: url)
    }
    
    /// Set custom setting
    public func setCustomSetting(_ value: Any, for key: String) {
        customSettings[key] = value
    }
    
    /// Get custom setting
    public func getCustomSetting<T>(for key: String) -> T? {
        return customSettings[key] as? T
    }
    
    /// Reset to default configuration
    public func resetToDefault() {
        loadDefaultConfiguration()
        customSettings.removeAll()
    }
    
    /// Validate configuration
    public func validate() -> [TestConfigurationError] {
        var errors: [TestConfigurationError] = []
        
        if timeout <= 0 {
            errors.append(.invalidTimeout(timeout))
        }
        
        if retryCount < 0 {
            errors.append(.invalidRetryCount(retryCount))
        }
        
        return errors
    }
    
    // MARK: - Private Methods
    
    private func loadDefaultConfiguration() {
        environment = .development
        timeout = 30.0
        retryCount = 3
        logLevel = .info
        enableLogging = true
        enableScreenshots = true
        enablePerformanceMonitoring = true
        enableNetworkMonitoring = true
    }
    
    private func applyConfiguration(_ config: ConfigurationData) {
        environment = config.environment
        timeout = config.timeout
        retryCount = config.retryCount
        logLevel = config.logLevel
        enableLogging = config.enableLogging
        enableScreenshots = config.enableScreenshots
        enablePerformanceMonitoring = config.enablePerformanceMonitoring
        enableNetworkMonitoring = config.enableNetworkMonitoring
    }
}

// MARK: - Supporting Types

/// Test Environment
public enum TestEnvironment: String, Codable, CaseIterable {
    case development = "development"
    case staging = "staging"
    case production = "production"
    case testing = "testing"
    
    public var apiBaseURL: String {
        switch self {
        case .development:
            return "https://dev-api.example.com"
        case .staging:
            return "https://staging-api.example.com"
        case .production:
            return "https://api.example.com"
        case .testing:
            return "https://test-api.example.com"
        }
    }
    
    public var databaseURL: String {
        switch self {
        case .development:
            return "dev_database"
        case .staging:
            return "staging_database"
        case .production:
            return "production_database"
        case .testing:
            return "test_database"
        }
    }
}

/// Log Level
public enum LogLevel: String, Codable, CaseIterable {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    
    public var priority: Int {
        switch self {
        case .debug: return 0
        case .info: return 1
        case .warning: return 2
        case .error: return 3
        }
    }
}

/// Configuration Data
public struct ConfigurationData: Codable {
    public let environment: TestEnvironment
    public let timeout: TimeInterval
    public let retryCount: Int
    public let logLevel: LogLevel
    public let enableLogging: Bool
    public let enableScreenshots: Bool
    public let enablePerformanceMonitoring: Bool
    public let enableNetworkMonitoring: Bool
    
    public init(environment: TestEnvironment, timeout: TimeInterval, retryCount: Int, logLevel: LogLevel, enableLogging: Bool, enableScreenshots: Bool, enablePerformanceMonitoring: Bool, enableNetworkMonitoring: Bool) {
        self.environment = environment
        self.timeout = timeout
        self.retryCount = retryCount
        self.logLevel = logLevel
        self.enableLogging = enableLogging
        self.enableScreenshots = enableScreenshots
        self.enablePerformanceMonitoring = enablePerformanceMonitoring
        self.enableNetworkMonitoring = enableNetworkMonitoring
    }
}

/// Test Configuration Error
public enum TestConfigurationError: LocalizedError {
    case fileNotFound(String)
    case invalidData(String)
    case invalidTimeout(TimeInterval)
    case invalidRetryCount(Int)
    case invalidEnvironment(String)
    
    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let file):
            return "Configuration file not found: \(file)"
        case .invalidData(let message):
            return "Invalid configuration data: \(message)"
        case .invalidTimeout(let timeout):
            return "Invalid timeout value: \(timeout)"
        case .invalidRetryCount(let count):
            return "Invalid retry count: \(count)"
        case .invalidEnvironment(let environment):
            return "Invalid environment: \(environment)"
        }
    }
} 