#if Latest
import KeywordsLatest
#elseif Swift6_3
import KeywordsSwift6_3
#elseif Swift6_2
import KeywordsSwift6_2
#elseif Swift6_1
import KeywordsSwift6_1
#elseif Swift6_0
import KeywordsSwift6_0
#else
import SwiftKeywordsContainer
#endif

func resolveDefaultVersion() -> KeywordsContainer {
	#if Latest
	return .latest
	#elseif Swift6_3
	return .v6_3
	#elseif Swift6_2
	return .v6_2
	#elseif Swift6_1
	return .v6_1
	#elseif Swift6_0
	return .v6_0
	#else
	return .empty
	#endif
}
