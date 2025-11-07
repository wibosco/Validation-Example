//
//  StubDebouncer.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 14/10/2025.
//

import Foundation

@testable import Validation_Example

actor StubDebouncer: Debouncer {
    enum Event {
        case submit(@Sendable () async -> Void)
    }
    
    private(set) var events = [Event]()
    
    private var continuation: CheckedContinuation<Void, Never>?

    func submit(_ action: @escaping @Sendable () async -> Void) async {
        events.append(.submit(action))
        continuation?.resume()
    }

    func waitForSubmit() async {
        await withCheckedContinuation { cont in
            continuation = cont
        }
    }
}
