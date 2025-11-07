//
//  StubDebouncer.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 14/10/2025.
//

import Foundation

@testable import Validation_Example

@MainActor
final class StubDebouncer: Debouncer {
    enum Event {
        case submit(@Sendable () async -> Void)
    }
    
    private(set) var events = [Event]()
    
    func submit(_ action: @escaping @Sendable () async -> Void) {
        events.append(.submit(action))
    }
}
