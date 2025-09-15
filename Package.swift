// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Analytics",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "AnalyticsCommon", targets: ["AnalyticsCommon"]),
        .library(name: "AnalyticsAmplitude", targets: ["AnalyticsAmplitude"]),
        .library(name: "AnalyticsTelemetryDeck", targets: ["AnalyticsTelemetryDeck"])
    ],
    dependencies: [
        .package(url: "https://github.com/amplitude/Amplitude-iOS", from: "8.22.2"),
        .package(url: "https://github.com/TelemetryDeck/SwiftClient", from: "2.9.4")
    ],
    targets: [
        .target(name: "AnalyticsCommon"),
        .target(
            name: "AnalyticsAmplitude",
            dependencies: [
                .byName(name: "AnalyticsCommon"),
                .product(name: "Amplitude", package: "Amplitude-iOS")
            ]
        ),
        .target(
            name: "AnalyticsTelemetryDeck",
            dependencies: [
                .byName(name: "AnalyticsCommon"),
                .product(name: "TelemetryClient", package: "SwiftClient")
            ]
        )
    ]
)
