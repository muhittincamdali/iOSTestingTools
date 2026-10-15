<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-tr-light.svg" alt="iOS Testing Automation: XCUITest için robotlar, kendini onaran locator'lar, ekran görüntüsü farkları, erişilebilirlik denetimleri ve CI raporları."></picture></p>

<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a></p>

# iOSTestingTools taşındı

Bu proje artık [iOS-Testing-Automation-Framework](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework) içinde yaşıyor. Bu depo arşivlendi ve artık değişiklik almıyor.

Tipli spy, medyan, p95 ve standart sapma veren benchmark ve SwiftUI snapshot renderer orada Swift 6 için, testlerle yeniden yazıldı; XCUITest robotları, kendini onaran locator'lar, ekran görüntüsü farkları, erişilebilirlik denetimleri ve CI raporlarıyla birlikte duruyor. Bu depodaki her şey taşınmadı: genel `Mock` actor'ı, `AutoMocker`, eski `SnapshotTools` ve `TestingTools` yardımcılarının yeni pakette karşılığı yok ve yeni paket tvOS ile watchOS'u artık desteklemiyor. [Changelog](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/CHANGELOG.md) nelerin birleştirildiğini listeliyor.

- Test double'ları: [Sources/iOSTestingAutomationFramework/Doubles](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Sources/iOSTestingAutomationFramework/Doubles)
- Benchmark: [Sources/iOSTestingAutomationFramework/Performance](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Sources/iOSTestingAutomationFramework/Performance)
- Snapshot: [Sources/iOSTestingAutomationFramework/Visual](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Sources/iOSTestingAutomationFramework/Visual)
- Dokümantasyon: [iOSTestingAutomationFramework](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/)

## Yeni paketi kurun

Yeni paket iOS 17+ veya macOS 14+ ve Swift 6.2 araçları gerektirir.

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

İki paket arasında public tipler değişti; geçiş import'ları ve çağrı yerlerini yeniden adlandırmayı gerektirir. Eski kod referans için burada olduğu gibi duruyor.
