// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Playground2",
    
    platforms: [.macOS(.v10_15)],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/mongodb/mongo-swift-driver", .upToNextMajor(from: "1.3.1")),
        .package(url: "https://github.com/apple/swift-nio", .upToNextMajor(from: "2.14.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "Playground2",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "MongoSwift", package: "mongo-swift-driver")
            ],
            path: "Sources/Playground2"),
        .testTarget(
            name: "Playground2Tests",
            dependencies: ["Playground2"]),
    ]
)
