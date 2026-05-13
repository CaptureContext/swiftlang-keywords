# swiftlang-keywords

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcapturecontext%2Fswiftlang-keywords%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/capturecontext/swiftlang-keywords) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcapturecontext%2Fswiftlang-keywords%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/capturecontext/swiftlang-keywords)

## Table of Contents

- [Motivation](#motivation)
- [Usage](#usage)
- [Installation](#installation)
- [Generating Sources](#generating-sources)
- [License](#license)

## Motivation

`swiftlang-keywords` is a lightweight library that provides precomputed Swift keyword sets for specific Swift language versions. Initially designed for [`package-resources-cli`](https://github.com/capturecontext/package-resources-cli) for code generation with [`swiftlang-snippets`](https://github.com/capturecontext/swiftlang-snippets).

## Usage

Import `SwiftKeywords` to use the default keyword set selected by package traits:

```swift
import SwiftKeywords

"actor".isSwiftKeyword         // true
"actor".isReservedSwiftKeyword // true

"userName".isSwiftKeyword         // false
"userName".isReservedSwiftKeyword // false

"Any".isSwiftKeyword         // true
"Any".isReservedSwiftKeyword // false

Set.swiftKeywords.contains("protocol") // true
Set.reservedSwiftKeywords.contains("protocol") // true
```

The `SwiftKeywords` product resolves its default version from the enabled trait. `Latest` is enabled by default and currently points to Swift 6.3.

You can temporarily use another keyword set with `withKeywords`:

```swift
import SwiftKeywords
import KeywordsSwift6_0

let result = withKeywords(.v6_0) {
	"borrow".isSwiftKeyword
}
```

You can also prepare a process-wide default before calling the convenience APIs:

```swift
import SwiftKeywords
import KeywordsSwift6_2

// Must be called before accessing
// primary APIs
prepareKeywords(with: .v6_2)
```

If you need direct access to a generated container, depend on one of the version products:

```swift
import KeywordsSwift6_3

let keywords = KeywordsContainer.v6_3
keywords.all             // all
keywords.lexerClassified // reserved
keywords.experimental    // always empty yet
```

## Installation

### Basic

You can add `swiftlang-keywords` to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter [`"https://github.com/capturecontext/swiftlang-keywords"`](https://github.com/capturecontext/swiftlang-keywords) into the package repository URL text field
3. Choose products you need to link to your project.

### Recommended

If you use SwiftPM for your project structure, add `swiftlang-keywords` dependency to your package file

```swift
.package(
	url: "https://github.com/capturecontext/swiftlang-keywords.git", 
	.upToNextMinor(from: "0.0.1"),
	traits: ["Latest"]
)
```

Available traits:

- `Latest` (default, enables `Swift6_3`)
- `Swift6_3`
- `Swift6_2`
- `Swift6_1`
- `Swift6_0`

Add the product to your target dependencies:

```swift
.product(
	name: "SwiftKeywords", 
	package: "swiftlang-keywords"
)
```

Generated version products are also available when you want an explicit keyword container:

```swift
.product(
	name: "KeywordsSwift6_3",
	package: "swiftlang-keywords"
)
```

## Generating Sources

Keyword source files are generated from `swift-syntax` by the local generator package.

Run the full generation sweep from the package root:

```sh
scripts/generate-keywords.sh
```

The script builds and runs the generator for:

- `600.0.0` -> `Sources/SwiftVersions/Swift6_0/Keywords.swift`
- `601.0.0` -> `Sources/SwiftVersions/Swift6_1/Keywords.swift`
- `602.0.0` -> `Sources/SwiftVersions/Swift6_2/Keywords.swift`
- `603.0.0` -> `Sources/SwiftVersions/Swift6_3/Keywords.swift`

To generate a single version manually:

```sh
GENERATE_SWIFT_SYNTAX_VERSION=603.0.0 \
GENERATE_SWIFT_KEYWORDS_PACKAGE_ROOT="$PWD" \
swift run --package-path generator keywords-generator-cli
```

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
