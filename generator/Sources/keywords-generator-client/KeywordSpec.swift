public struct KeywordSpec: Sendable, Hashable {
	public var stringValue: String
	public var isLexerClassified: Bool
	public var isExperimental: Bool?

	public init(
		stringValue: String,
		isLexerClassified: Bool,
		isExperimental: Bool?
	) {
		self.stringValue = stringValue
		self.isLexerClassified = isLexerClassified
		self.isExperimental = isExperimental
	}
}
