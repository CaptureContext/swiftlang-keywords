#!/usr/bin/env bash
set -euo pipefail

swift_syntax_versions=(
	"600.0.0"
	"601.0.0"
	"602.0.0"
	"603.0.0"
)

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
package_root="$(cd "$script_dir/.." && pwd)"
generator_dir="$package_root/generator"
swift_bin="${SWIFT:-swift}"

for swift_syntax_version in "${swift_syntax_versions[@]}"; do
	echo "Building keywords generator for swift-syntax $swift_syntax_version"
	GENERATE_SWIFT_SYNTAX_VERSION="$swift_syntax_version" \
		"$swift_bin" build \
		--package-path "$generator_dir" \
		--product keywords-generator-cli

	echo "Generating Swift keywords for swift-syntax $swift_syntax_version"
	GENERATE_SWIFT_SYNTAX_VERSION="$swift_syntax_version" \
		GENERATE_SWIFT_KEYWORDS_PACKAGE_ROOT="$package_root" \
		"$swift_bin" run \
		--package-path "$generator_dir" \
		--skip-build \
		keywords-generator-cli
done
