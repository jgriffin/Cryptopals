// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cryptopals",
    platforms: [
        .macOS(.v13), .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Cryptopals",
            targets: ["Cryptopals"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
        .package(url: "https://github.com/jgriffin/EulerTools.git", from: "0.2.3"),
        // .package(url: "https://github.com/jgriffin/WordTools.git", from: "0.1.0"),
        .package(path: "../WordTools"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Cryptopals",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "EulerTools", package: "EulerTools"),
                .product(name: "WordTools", package: "WordTools"),
            ]),
        .testTarget(
            name: "CryptopalsTests",
            dependencies: [
                "Cryptopals",
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "EulerTools", package: "EulerTools"),
                .product(name: "WordTools", package: "WordTools"),
            ],
            resources: [.process("resources")]
),
    ])
