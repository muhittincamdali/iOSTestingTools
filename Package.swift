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
    ],
    dependencies: [],
    targets: [
        .target(
            name: "iOSTestingTools",
            dependencies: [],
            path: "Sources/iOSTestingTools",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "iOSTestingToolsTests",
            dependencies: ["iOSTestingTools"],
            path: "Tests"
        )
    ]
)
