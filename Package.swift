// swift-tools-version:5.9
//
// Package.swift
// HTMLBridge
//
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HTMLBridge",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "HTMLBridge",
            targets: ["HTMLBridge"]
        )
    ],
    targets: [
        .target(
            name: "HTMLBridge"
        )
    ]
)
