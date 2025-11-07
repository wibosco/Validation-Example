//
//  Debouncer.swift
//  Validation-Example
//
//  Created by William Boles on 07/11/2025.
//

import Foundation

protocol Debouncer {
    func submit(_ action: @escaping @Sendable () async -> Void) async
}

actor DefaultDebouncer: Debouncer {
    private let delay: Duration
    private var task: Task<Void, Never>?
    
    // MARK: - Init
    
    init(delay: Duration) {
        self.delay = delay
    }
    
    // MARK: - Submit

    func submit(_ action: @escaping @Sendable () async -> Void) {
        task?.cancel()
        task = Task {
            try? await Task.sleep(for: delay)
            guard !Task.isCancelled else { return }
            await action()
        }
    }
}
