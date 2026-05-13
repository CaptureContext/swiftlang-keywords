import Snippets
import SwiftSnippets

@concurrent
public func renderKeywordsContainerDecl(
	for keywords: [KeywordSpec],
	withIdentifier identifier: String
) async -> String {
	Snippets.KeywordsContainerExtension(
		identifier: identifier,
		keywords: keywords
	).render()
}

extension Snippets {
	struct KeywordsContainerExtension: Snippet {
		let identifier: String
		let keywords: [KeywordSpec]

		init(
			identifier: String,
			keywords: [KeywordSpec]
		) {
			self.identifier = identifier
			self.keywords = keywords
		}

		var content: some Snippet<String> {
			Snippets.ExtensionDecl(
				extendedType: .init(snippetLiteral: "KeywordsContainer"),
				body: {
					KeywordsContainerProperty(
						identifier: identifier,
						keywords: keywords
					)
				}
			)
		}
	}

	struct KeywordsContainerProperty: Snippet {
		let identifier: String
		let keywords: [KeywordSpec]

		init(
			identifier: String,
			keywords: [KeywordSpec]
		) {
			self.identifier = identifier
			self.keywords = keywords
		}

		var content: some Snippet<String> {
			Snippets.ComputedPropertyDecl(
				accessLevel: .public,
				isStatic: true,
				identifier: .init(identifier),
				type: .init(snippetLiteral: "Self"),
				getter: Snippets.PropertyGetterDecl {
					KeywordsContainerInit(keywords)
				}
			)
		}
	}

	struct KeywordsContainerInit: Snippet {
		let keywords: [KeywordSpec]

		init(_ keywords: [KeywordSpec]) {
			self.keywords = keywords
		}

		var content: some Snippet<String> {
			Snippets.CallExpr(
				callee: Snippets.Const(".init"),
				clause: [
					Snippets.CallArgument(
						label: .init("all"),
						value: Snippets.KeywordsList(keywords)
					),
					Snippets.CallArgument(
						label: .init("lexerClassified"),
						value: Snippets.KeywordsList(keywords.filter(\.isLexerClassified))
					),
					Snippets.CallArgument(
						label: .init("experimental"),
						value: Snippets.KeywordsList([])
					),
				]
			)
		}
	}

	struct KeywordsList: Snippet {
		let keywords: [KeywordSpec]

		init(_ keywords: [KeywordSpec]) {
			self.keywords = keywords
		}

		var content: some Snippet<String> {
			if keywords.isEmpty {
				"[]"
			} else {
				Bracket(in: .brackets.withInner(.init(.newline))) {
					Indent {
						Snippets.Join(.const(.comma.suffixed(with: .newline))) {
							keywords.map { keyword in
								Bracket(keyword.stringValue.makeSnippet(), in: .quotes())
							}
						}
					}
				}
			}
		}
	}
}
