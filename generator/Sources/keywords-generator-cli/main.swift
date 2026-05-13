import Foundation
import KeywordsGeneratorClient

struct SwiftSyntaxVersion {
	let rawValue: String
	let swiftMajor: Int
	let swiftMinor: Int

	init(_ rawValue: String) throws {
		let versionComponents = rawValue.split(separator: ".")
		guard let languageVersionComponent = versionComponents.first,
		      let languageVersion = Int(languageVersionComponent)
		else {
			throw GeneratorError.invalidSwiftSyntaxVersion(rawValue)
		}

		self.rawValue = rawValue
		self.swiftMajor = languageVersion / 100
		self.swiftMinor = languageVersion % 100
	}

	var directoryName: String {
		"Swift\(swiftMajor)_\(swiftMinor)"
	}

	var keywordsIdentifier: String {
		"v\(swiftMajor)_\(swiftMinor)"
	}
}

enum GeneratorError: LocalizedError {
	case invalidSwiftSyntaxVersion(String)
	case missingSwiftVersionsDirectory(URL)

	var errorDescription: String? {
		switch self {
		case let .invalidSwiftSyntaxVersion(rawValue):
			"Invalid GENERATE_SWIFT_SYNTAX_VERSION value: \(rawValue)"
		case let .missingSwiftVersionsDirectory(packageRoot):
			"Could not find Sources/SwiftVersions in package root: \(packageRoot.path)"
		}
	}
}

func packageRoot(
	env: [String: String],
	fileManager: FileManager = .default
) throws -> URL {
	if let packageRoot = env["GENERATE_SWIFT_KEYWORDS_PACKAGE_ROOT"]
		?? env["GENERATE_SWIFT_KEYWORDS_OUTPUT_ROOT"]
	{
		return URL(fileURLWithPath: packageRoot)
	}

	let currentDirectory = URL(fileURLWithPath: fileManager.currentDirectoryPath)
	let candidates = [
		currentDirectory,
		currentDirectory.deletingLastPathComponent(),
	]

	for candidate in candidates {
		let swiftVersionsDirectory = candidate
			.appendingPathComponent("Sources")
			.appendingPathComponent("SwiftVersions")

		var isDirectory: ObjCBool = false
		if fileManager.fileExists(
			atPath: swiftVersionsDirectory.path,
			isDirectory: &isDirectory
		), isDirectory.boolValue {
			return candidate
		}
	}

	throw GeneratorError.missingSwiftVersionsDirectory(currentDirectory)
}

func run() async throws {
	let fileManager = FileManager.default
	let env = ProcessInfo.processInfo.environment
	let versionString = env["GENERATE_SWIFT_SYNTAX_VERSION"] ?? "603.0.0"
	let swiftSyntaxVersion = try SwiftSyntaxVersion(versionString)
	let packageRoot = try packageRoot(env: env, fileManager: fileManager)
	let swiftVersionsDirectory = packageRoot
		.appendingPathComponent("Sources")
		.appendingPathComponent("SwiftVersions")

	var isDirectory: ObjCBool = false
	guard fileManager.fileExists(
		atPath: swiftVersionsDirectory.path,
		isDirectory: &isDirectory
	), isDirectory.boolValue else {
		throw GeneratorError.missingSwiftVersionsDirectory(packageRoot)
	}

	let outputDirectory = swiftVersionsDirectory
		.appendingPathComponent(swiftSyntaxVersion.directoryName)
	let outputFile = outputDirectory.appendingPathComponent("Keywords.swift")
	let generatedExtension = await renderKeywordsContainerDecl(
		for: await KeywordSpec.collect(),
		withIdentifier: swiftSyntaxVersion.keywordsIdentifier
	)
	let output = """
	@_exported import SwiftKeywordsContainer

	\(generatedExtension)
	"""

	try fileManager.createDirectory(
		at: outputDirectory,
		withIntermediateDirectories: true
	)
	try output.write(
		to: outputFile,
		atomically: true,
		encoding: .utf8
	)

	print("Generated \(outputFile.path) for swift-syntax \(swiftSyntaxVersion.rawValue)")
}

try await run()
