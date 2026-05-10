// swift-tools-version: 6.0
//
//  Package.swift
//  FeatureHome
//
//  Created by jch on 4/27/26.
//

import PackageDescription

let package = Package(
    name: "FeatureHome",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "FeatureHome",
            targets: ["FeatureHome"]
        )
    ],
    dependencies: [
        .package(path: "../../Core/UI/DesignSystem")
    ],
    targets: [
        .target(
            name: "FeatureHome",
            dependencies: [
                "DesignSystem"
            ],
            path: "Sources/FeatureHome",
            linkerSettings: [
                
            ]
        ),
        .testTarget(
            name: "FeatureHomeTests",
            dependencies: [
                "FeatureHome"
            ],
            path: "Tests/FeatureHomeTests",
            linkerSettings: [
                
            ]
        )
    ]
)
