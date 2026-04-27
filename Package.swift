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
        
    ],
    targets: [
        .target(
            name: "FeatureHome",
            dependencies: [
                
            ],
            path: "Sources/FeatureHome",
            linkerSettings: [
                
            ]
        ),
        .testTarget(
            name: "FeatureHomeTests",
            dependencies: [
                
            ],
            path: "Tests/FeatureHomeTests",
            linkerSettings: [
                
            ]
        )
    ]
)
