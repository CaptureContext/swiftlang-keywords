import SwiftKeywordsContainer

extension StringProtocol {
	@inlinable
	public var isSwiftKeyword: Bool {
		String(self).isSwiftKeyword
	}

	@inlinable
	public var isReservedSwiftKeyword: Bool {
		String(self).isReservedSwiftKeyword
	}
}

extension String {
	@inlinable
	public var isSwiftKeyword: Bool {
		Set.swiftKeywords.contains(self)
	}

	@inlinable
	public var isReservedSwiftKeyword: Bool {
		Set.reservedSwiftKeywords.contains(self)
	}
}

extension Set where Element == String {
	public static var swiftKeywords: Self {
		Set(KeywordsContainer.current.all)
	}


	public static var reservedSwiftKeywords: Self {
		Set(KeywordsContainer.current.all)
	}
}
