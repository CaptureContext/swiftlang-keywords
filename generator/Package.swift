// swift-tools-version: 6.1

import PackageDescription

let package = Package(
	name: "swiftlang-keywords-package-generator",
	platforms: [
		.macOS(.v10_15),
	],
	products: [
		.executable(
			name: "keywords-generator-cli",
			targets: ["keywords-generator-cli"]
		),
		.library(
			name: "KeywordsGeneratorClient",
			targets: ["KeywordsGeneratorClient"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/swiftlang/swift-syntax.git",
			"509.0.0"..<"605.0.0"
		),
		.package(
			url: "https://github.com/capturecontext/swiftlang-snippets.git",
			branch: "main"
		),
	],
	targets: [
		.executableTarget(
			name: "keywords-generator-cli",
			dependencies: [
				.target(name: "KeywordsGeneratorClient"),
			]
		),
		.target(
			name: "KeywordsGeneratorClient",
			dependencies: [
				.product(
					name: "SwiftSyntax",
					package: "swift-syntax"
				),
				.product(
					name: "SwiftParser",
					package: "swift-syntax"
				),
				.product(
					name: "SwiftSnippets",
					package: "swiftlang-snippets"
				),
			],
			path: "Sources/keywords-generator-client"
		),
	],
	swiftLanguageModes: [.v6]
)
