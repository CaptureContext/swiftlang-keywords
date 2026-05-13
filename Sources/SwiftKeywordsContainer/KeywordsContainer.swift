public struct KeywordsContainer: Sendable, Hashable {
	public let all: Set<String>
	public let lexerClassified: Set<String>
	public let experimental: Set<String>

	public init(
		all: Set<String>,
		lexerClassified: Set<String>,
		experimental: Set<String>
	) {
		self.all = all
		self.lexerClassified = lexerClassified
		self.experimental = experimental
	}

	public static var empty: Self {
		.init(
			all: [],
			lexerClassified: [],
			experimental: []
		)
	}
}
