@_spi(ExperimentalLanguageFeatures)
@_spi(RawSyntax)
import SwiftSyntax

@_spi(Diagnostics)
import SwiftParser

extension Keyword: @retroactive CaseIterable {
	public static var allCases: [Keyword] {
		(UInt8.min...UInt8.max).reduce(into: []) { buffer, rawValue in
			if let keyword = Keyword(rawValue: rawValue) {
				buffer.append(keyword)
			}
		}
	}
}

extension KeywordSpec {
	@concurrent
	public static func collect() async -> [Self] {
		Keyword.allCases.map { keyword in
			KeywordSpec(
				stringValue: keyword.defaultText.description,
				isLexerClassified: TokenKind.keyword(keyword).isLexerClassifiedKeyword,
				isExperimental: nil
			)
		}
	}
}
