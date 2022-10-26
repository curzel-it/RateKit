// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "RateKit",
    platforms: [.macOS(.v11), .iOS(.v11)],
    products: [
        .library(
            name: "RateKit",
            targets: ["RateKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RateKit",
            dependencies: []
        ),
        .testTarget(
            name: "RateKitTests",
            dependencies: ["RateKit"]
        )
    ]
)
