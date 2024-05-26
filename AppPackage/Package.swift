// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target.Dependency {
//    static var fetchingView: Self {
//        .product(name: "FetchingView", package: "FetchingView")
//    }
}

let package = Package(
    name: "AppPackage",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "PostListFeature",
            targets: ["PostListFeature"]
        ),
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
    ],
    targets: [
        .target(name: "Models"),
        .target(
            name: "ServiceClient",
            dependencies: ["Models"]
        ),
        .target(name: "UIUtilities"),
        .target(
            name: "ViewModel",
            dependencies: ["ServiceClient"]
        ),
        .target(name: "PostSupport", dependencies: ["Models"]),
        .target(
            name: "PostListFeature",
            dependencies: ["ViewModel", "UIUtilities", "PostSupport"]
        ),
        .target(
            name: "PostDetailsFeature",
            dependencies: ["ViewModel", "UIUtilities", "PostSupport"]
        ),
        .target(
            name: "AppFeature",
            dependencies: ["PostListFeature", "PostDetailsFeature"]
        ),
    ]
)
