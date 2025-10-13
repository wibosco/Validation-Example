//
//  Debouncer.swift
//  Validation-Example
//
//  Created by William Boles on 13/10/2025.
//

import Foundation

protocol Debouncer: Sendable {
    func submit(_ action: @escaping @Sendable () async -> Void) async
}

actor DefaultDebouncer: Debouncer {
    private var task: Task<Void, Never>?
    private let duration: Duration
    
    // MARK: - Init
    
    init(duration: Duration) {
        self.duration = duration
    }
    
    // MARK: - Debouncing
    
    func submit(_ action: @escaping @Sendable () async -> Void) {
        task?.cancel()
        
        task = Task {
            try? await Task.sleep(for: duration)
            
            guard !Task.isCancelled else {
                return
            }
            
            await action()
            
            self.task = nil
        }
    }
}
