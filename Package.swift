// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUtils",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftUtils",
            targets: ["SwiftUtils"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ninjaprox/NVActivityIndicatorView.git", exact: "5.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftUtils",
            dependencies: [
                "NVActivityIndicatorView",
            ]),
        .testTarget(
            name: "SwiftUtilsTests",
            dependencies: ["SwiftUtils"]),
    ]
)
