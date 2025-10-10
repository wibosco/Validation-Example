//
//  ValidatedFieldViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//

import Foundation
import Combine
import CombineSchedulers

enum ValidatedState {
    case empty
    case valid
    case invalid(Error)
    
    var isValid: Bool {
        guard case .valid = self else {
            return false
        }
        
        return true
    }
    
    var isInvalid: Bool {
        guard case .invalid(_) = self else {
            return false
        }
        
        return true
    }
}

final class DebouncedValidationPublisherFactory {
    private let scheduler: AnySchedulerOf<RunLoop>
    
    // MARK: - Init
    
    init(scheduler: AnySchedulerOf<RunLoop>) {
        self.scheduler = scheduler
    }
    
    // MARK: - Factory
    
    func createPublisher<V: Validator>(_ value: Published<String>.Publisher,
                                       validator: V) -> AnyPublisher<ValidatedState, Never> {
        value
            .debounce(for: .seconds(1),
                      scheduler: scheduler)
            .removeDuplicates()
            .map { newValue in
                guard !newValue.isEmpty else {
                    return .empty
                }
                
                do {
                    try validator.validate(newValue)
                    return .valid
                } catch {
                    return .invalid(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
