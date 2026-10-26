// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "YatayatSewa",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "YatayatSewa", targets: ["YatayatSewa"])
    ],
    targets: [
        .target(name: "YatayatSewa"),
        .testTarget(name: "YatayatSewaTests", dependencies: ["YatayatSewa"])
    ]
)
