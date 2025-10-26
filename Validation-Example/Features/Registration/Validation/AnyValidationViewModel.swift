//
//  AnyValidationViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 20/10/2025.
//

import Foundation

@Observable
final class AnyValidationViewModel<Value: Sendable & Equatable>: ValidationViewModel {
    private var wrappedViewModel: any ValidationViewModel<Value>
    
    var value: Value {
        get { wrappedViewModel.value }
        set { wrappedViewModel.value = newValue }
    }
    
    var validationState: ValidatedState {
        wrappedViewModel.validationState
    }
    
    init<ViewModel: ValidationViewModel>(_ viewModel: ViewModel) where ViewModel.Value == Value {
        self.wrappedViewModel = viewModel
    }
}

extension ValidationViewModel {
    func eraseToAnyValidationViewModel() -> AnyValidationViewModel<Value> {
        AnyValidationViewModel(self)
    }
}
