// swift-tools-version:4.0


import PackageDescription

let package = Package(
    name: "PilotCLI",
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
        .package(url: "https://github.com/tomlokhorst/XcodeEdit", from: "2.3.0"),
        .package(url: "https://github.com/kylef/Stencil.git", from: "0.11.0"),
        .package(url: "https://github.com/Bouke/INI", from: "1.0.2"),
    ],
    targets: [
        .target(
            name: "PilotCLI",
            dependencies: ["PilotCLICore"]),
        .target(
            name: "PilotCLICore",
            dependencies: ["RswiftCore","Stencil","INI"]),
        .target(
            name: "RswiftCore",
            dependencies: ["Commander", "XcodeEdit"]),
    ]
)
