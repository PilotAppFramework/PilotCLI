// swift-tools-version:4.0


import PackageDescription

let package = Package(
    name: "PilotCLI",
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
        .package(url: "https://github.com/tomlokhorst/XcodeEdit", from: "2.3.0")
    ],
    targets: [
        .target(
            name: "PilotCLI",
            dependencies: ["PilotCLICore"]),
        .target(
            name: "PilotCLICore",
            dependencies: ["Commander", "XcodeEdit"]),
    ]
)
