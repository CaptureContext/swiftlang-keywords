// swift-tools-version: 6.1

import PackageDescription

let package = Package(
	name: "swiftlang-keywords",
	platforms: [
		.macOS(.v10_15),
		.macCatalyst(.v13),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6)
	],
	products: [
		.library(
			name: "SwiftKeywords",
			targets: ["SwiftKeywords"]
		),
		.swiftVersionTarget(for: .latest),
		.swiftVersionTarget(for: .v6_3),
		.swiftVersionTarget(for: .v6_2),
		.swiftVersionTarget(for: .v6_1),
		.swiftVersionTarget(for: .v6_0),
	],
	targets: [
		.target(
			name: "SwiftKeywords",
			dependencies: [
				.swiftVersionTarget(for: .latest),
				.swiftVersionTarget(for: .v6_3),
				.swiftVersionTarget(for: .v6_2),
				.swiftVersionTarget(for: .v6_1),
				.swiftVersionTarget(for: .v6_0),
			]
		),
		.target(
			name: "SwiftKeywordsContainer",
			dependencies: []
		),
		.swiftVersionTarget(for: .latest),
		.swiftVersionTarget(for: .v6_3),
		.swiftVersionTarget(for: .v6_2),
		.swiftVersionTarget(for: .v6_1),
		.swiftVersionTarget(for: .v6_0),
	],
	swiftLanguageModes: [.v6]
)

extension Product {
	static func swiftVersionTarget(for trait: Trait) -> Product {
		return .library(
			name: "Keywords\(trait.name)",
			targets: ["Keywords\(trait.name)"]
		)
	}
}

extension Target {
	static func swiftVersionTarget(for trait: Trait) -> Target {
		var dependencies: [Target.Dependency] = [
			.target(name: "SwiftKeywordsContainer"),
		]

		if trait == .latest {
			dependencies.append(.swiftVersionTarget(
				for: ._latestVersion,
				force: true
			))
		}

		return .target(
			name: "Keywords\(trait.name)",
			dependencies: dependencies,
			path: "Sources/SwiftVersions/\(trait.name)"
		)
	}
}

extension Target.Dependency {
	static func swiftVersionTarget(
		for trait: Trait,
		force: Bool = false
	) -> Target.Dependency {
		if force {
			return .target(name: "Keywords\(trait.name)")
		} else {
			return .target(
				name: "Keywords\(trait.name)",
				condition: .when(traits: [trait.name])
			)
		}
	}
}

extension Trait {
	static var _latestVersion: Self { .v6_3 }

	static var latest: Self {
		.trait(
			name: "Latest",
			description: "Uses latest Swift version (6.3) as default"
		)
	}

	static var v6_0: Self {
		.trait(
			name: "Swift6_0",
			description: "Uses Swift 6.0 as default"
		)
	}

	static var v6_1: Self {
		.trait(
			name: "Swift6_1",
			description: "Uses Swift 6.1 as default"
		)
	}

	static var v6_2: Self {
		.trait(
			name: "Swift6_2",
			description: "Uses Swift 6.2 as default"
		)
	}

	static var v6_3: Self {
		.trait(
			name: "Swift6_3",
			description: "Uses Swift 6.3 as default"
		)
	}
}

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

// Workaround to ensure that all traits are included in documentation. Swift Package Index adds
// SPI_GENERATE_DOCS (https://github.com/SwiftPackageIndex/SwiftPackageIndex-Server/issues/2336)
// when building documentation, so only tweak the default traits in this condition.
let spiGenerateDocs = ProcessInfo.processInfo.environment["SPI_GENERATE_DOCS"] != nil

// Enable all traits for other CI actions.
let enableAllTraitsExplicit = ProcessInfo.processInfo.environment["ENABLE_ALL_TRAITS"] != nil

let enableAllTraits = spiGenerateDocs || enableAllTraitsExplicit

package.traits.formUnion([
	.latest,
	.v6_0,
	.v6_1,
	.v6_2,
	.v6_3,
])

package.traits.insert(.default(
	enabledTraits: Set(enableAllTraits ? package.traits.map(\.name) : [Trait.latest.name])
))
