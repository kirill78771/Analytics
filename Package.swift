// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Analytics",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "AnalyticsCommon", targets: ["AnalyticsCommon"]),
        .library(name: "AnalyticsAmplitude", targets: ["AnalyticsAmplitude"])
    ],
    dependencies: [
        .package(url: "https://github.com/amplitude/Amplitude-iOS", from: "8.3.0")
    ],
    targets: [
        .target(name: "AnalyticsCommon"),
        .target(
            name: "AnalyticsAmplitude",
            dependencies: [
                .byName(name: "AnalyticsCommon"),
                .product(name: "Amplitude", package: "Amplitude-iOS")
            ]
        )
    ]
)
