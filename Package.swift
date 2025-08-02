// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "iOSTestingTools",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(name: "iOSTestingTools", targets: ["iOSTestingTools"]),
        .library(name: "UnitTesting", targets: ["UnitTesting"]),
        .library(name: "UITesting", targets: ["UITesting"]),
        .library(name: "IntegrationTesting", targets: ["IntegrationTesting"]),
        .library(name: "PerformanceTesting", targets: ["PerformanceTesting"]),
        .library(name: "DebugTesting", targets: ["DebugTesting"]),
        .library(name: "TestUtilities", targets: ["TestUtilities"])
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.54.0")
    ],
    targets: [
        .target(
            name: "iOSTestingTools",
            dependencies: [
                "UnitTesting",
                "UITesting",
                "IntegrationTesting",
                "PerformanceTesting",
                "DebugTesting",
                "TestUtilities"
            ]
        ),
        .target(
            name: "UnitTesting",
            dependencies: []
        ),
        .target(
            name: "UITesting",
            dependencies: []
        ),
        .target(
            name: "IntegrationTesting",
            dependencies: []
        ),
        .target(
            name: "PerformanceTesting",
            dependencies: []
        ),
        .target(
            name: "DebugTesting",
            dependencies: []
        ),
        .target(
            name: "TestUtilities",
            dependencies: []
        ),
        .testTarget(
            name: "iOSTestingToolsTests",
            dependencies: ["iOSTestingTools"]
        )
    ]
) 