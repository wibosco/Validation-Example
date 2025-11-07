//
//  Debouncer.swift
//  Validation-Example
//
//  Created by William Boles on 07/11/2025.
//

import Foundation

@MainActor
protocol Debouncer {
    func submit(_ action: @escaping @Sendable () async -> Void)
    func callAsFunction(_ action: @escaping @Sendable () async -> Void)
}

@MainActor
final class DefaultDebouncer: Debouncer {
    private let delay: Duration
    private var task: Task<Void, Never>?

    init(delay: Duration) {
        self.delay = delay
    }

    func submit(_ action: @escaping @Sendable () async -> Void) {
        task?.cancel()
        task = Task {
            try? await Task.sleep(for: delay)

            guard !Task.isCancelled else { return }
            
            await action()
        }
    }

    func callAsFunction(_ action: @escaping @Sendable () async -> Void) {
        submit(action)
    }
}
