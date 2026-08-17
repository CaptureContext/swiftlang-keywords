import Foundation
import SwiftKeywordsContainer

extension KeywordsContainer {
	static let _initialValue: Box = .init()

	@TaskLocal
	static var current: KeywordsContainer = _initialValue.container

	final class Box: @unchecked Sendable {
		private let lock = NSRecursiveLock()
		private var _container: KeywordsContainer = resolveDefaultVersion()

		var container: KeywordsContainer { lock.withLock { self._container } }

		func setContainer(_ container: KeywordsContainer) {
			lock.withLock { self._container = container }
		}
	}
}

public func prepareKeywords(_ container: KeywordsContainer) {
	KeywordsContainer._initialValue.setContainer(container)
}

@discardableResult
public func withKeywords<R>(
	_ container: KeywordsContainer,
	perform operation: @Sendable () throws -> R
) rethrows -> R {
	try KeywordsContainer.$current.withValue(
		container,
		operation: operation
	)
}

@discardableResult
public func withKeywords<R>(
	_ container: KeywordsContainer,
	perform operation: @Sendable () async throws -> R
) async rethrows -> R {
	try await KeywordsContainer.$current.withValue(
		container,
		operation: operation
	)
}
