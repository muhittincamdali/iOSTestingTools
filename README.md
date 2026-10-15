<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-light.svg" alt="iOS Testing Automation: Robots, self-healing locators, screenshot diffs, accessibility audits and CI reports for XCUITest."></picture></p>

<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a></p>

# iOSTestingTools has moved

This project now lives in [iOS-Testing-Automation-Framework](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework). This repository is archived and no longer receives changes.

The typed spy, the benchmark with median, p95 and standard deviation, and the SwiftUI snapshot renderer were rewritten there for Swift 6, with tests, next to XCUITest robots, self-healing locators, screenshot diffs, accessibility audits and CI reports. Not everything from this repository was carried over: the generic `Mock` actor, `AutoMocker`, the old `SnapshotTools` and `TestingTools` helpers have no counterpart in the new package, and it no longer supports tvOS or watchOS. The [changelog](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/CHANGELOG.md) lists what was merged.

- Test doubles: [Sources/iOSTestingAutomationFramework/Doubles](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Sources/iOSTestingAutomationFramework/Doubles)
- Benchmarks: [Sources/iOSTestingAutomationFramework/Performance](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Sources/iOSTestingAutomationFramework/Performance)
- Snapshots: [Sources/iOSTestingAutomationFramework/Visual](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Sources/iOSTestingAutomationFramework/Visual)
- Documentation: [iOSTestingAutomationFramework](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/)

## Install the new package

The new package needs iOS 17+ or macOS 14+ and Swift 6.2 tools.

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git", from: "2.0.0")
],
targets: [
    .testTarget(name: "YourAppTests", dependencies: [
        .product(name: "iOSTestingAutomationFramework", package: "iOS-Testing-Automation-Framework")
    ])
]
```

The public types changed between the two packages, so moving over means renaming imports and call sites. The old code stays here, unchanged, for reference.
