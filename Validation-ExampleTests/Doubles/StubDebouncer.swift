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
        case callAsFunction(() async -> Void)
    }
    
    private(set) var events = [Event]()
    
    func callAsFunction(_ action: @escaping () async -> Void) {
        events.append(.callAsFunction(action))
    }
}
