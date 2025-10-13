//
//  Debouncer.swift
//  Validation-Example
//
//  Created by William Boles on 13/10/2025.
//

import Foundation

protocol Debouncer: Sendable {
    func submit(key: String,
                _ action: @escaping @Sendable () async -> Void) async
    func cancel(key: String) async
    func cancelAll() async
}

actor DefaultDebouncer: Debouncer {
    private var tasks: [String: Task<Void, Never>] = [:]
    private let duration: Duration
    
    // MARK: - Init
    
    init(duration: Duration) {
        self.duration = duration
    }
    
    // MARK: - Debouncing
    
    func submit(key: String,
                _ action: @escaping @Sendable () async -> Void) {
        tasks[key]?.cancel()
        
        tasks[key] = Task {
            try? await Task.sleep(for: duration)
            
            guard !Task.isCancelled else {
                return
            }
            
            await action()
            
            self.removeTask(for: key)
        }
    }
    
    private func removeTask(for key: String) {
        tasks[key] = nil
    }
    
    // MARK: - Cancel
    
    func cancel(key: String) {
        tasks[key]?.cancel()
        tasks[key] = nil
    }
    
    func cancelAll() {
        tasks.values.forEach { $0.cancel() }
        tasks.removeAll()
    }
}

extension DefaultDebouncer {
    static let validationDebouncer = DefaultDebouncer(duration: .seconds(1))
}
