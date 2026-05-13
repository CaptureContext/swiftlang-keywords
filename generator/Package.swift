// swift-tools-version: 6.1

import PackageDescription

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

extension Version {
	/// swift-syntax version, for example "600.0.0"
	static var swiftSyntaxVersion: Self {
		let env = ProcessInfo.processInfo.environment
		let versionString = env["GENERATE_SWIFT_SYNTAX_VERSION"]
		?? "603.0.0"
		// ?? "Env GENERATE_SWIFT_SYNTAX_VERSION is missing"
		return Version(stringLiteral: versionString)
	}
}

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
			exact: .swiftSyntaxVersion
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
