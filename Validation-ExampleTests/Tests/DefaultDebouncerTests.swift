//
//  DefaultDebouncer.swift
//  Validation-ExampleTests
//
//  Created by William Boles on 14/10/2025.
//

import Testing

@testable import Validation_Example

struct DefaultDebouncerTests {
    var sut: DefaultDebouncer!
    
    // MARK: - Init
    
    init() {
        sut = DefaultDebouncer(delay: .milliseconds(100))
    }
    
    // MARK: - Tests
    
    @Test("Given an action is scheduled on the debouncer, when the duration passed, then that action should be triggered")
    func submitedActionIsTriggeredAfterDuration() async throws {
        actor Flag {
            private(set) var ran = false
            func mark() { ran = true }
        }
        
        let flag = Flag()

        sut.submit {
            await flag.mark()
        }

        // Too early
        try await Task.sleep(for: .milliseconds(50))
        
        #expect(await flag.ran == false)

        // Long enough
        try await Task.sleep(for: .milliseconds(100))
        
        #expect(await flag.ran == true)
    }
    
    @Test("Given an action is scheduled on the debouncer, when a second action is scheduled, then the first action should be cancelled")
    func submittingTwiceOnlyYieldsOneEvent() async throws {
        actor Flag {
            private(set) var firstRan = false
            private(set) var secondRan = false
            func markFirstRan() { firstRan = true }
            func markSecondRan() { secondRan = true }
        }
        
        let flag = Flag()

        sut.submit {
            await flag.markFirstRan()
        }

        sut.submit {
            await flag.markSecondRan()
        }

        try await Task.sleep(for: .milliseconds(150))
        
        #expect(await flag.firstRan == false)
        #expect(await flag.secondRan == true)
    }
}
