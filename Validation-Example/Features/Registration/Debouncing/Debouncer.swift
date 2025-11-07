//
//  Debouncer.swift
//  Validation-Example
//
//  Created by William Boles on 07/11/2025.
//

import Foundation

@MainActor
protocol Debouncer {
    func callAsFunction(_ action: @escaping () async -> Void)
}

@MainActor
final class DefaultDebouncer: Debouncer {
    private let delay: Duration
    private var task: Task<Void, Never>?

    // MARK: - Init
    
    init(delay: Duration) {
        self.delay = delay
    }
    
    // MARK: - Debouncing
    
    private func submit(_ action: @escaping () async -> Void) {
        task?.cancel()
        task = Task {
            try? await Task.sleep(for: delay)

            guard !Task.isCancelled else {
                return
            }
            
            await action()
        }
    }

    func callAsFunction(_ action: @escaping () async -> Void) {
        submit(action)
    }
}
