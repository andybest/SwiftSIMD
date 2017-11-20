// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSIMD",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftSIMD",
            targets: ["SwiftSIMD"]),
        .executable (
            name: "GenBoilerplate",
            targets: ["GenBoilerplate"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.0.1"),
        .package(url: "https://github.com/kylef/Commander.git", from: "0.6.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftSIMD",
            dependencies: []),
        .target(
            name: "GenBoilerplate",
            dependencies: ["StencilSwiftKit", "Commander"]),
        .testTarget(
            name: "SwiftSIMDTests",
            dependencies: ["SwiftSIMD"]),
    ]
)
