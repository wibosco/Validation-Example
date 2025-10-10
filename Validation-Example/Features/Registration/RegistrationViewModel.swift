//
//  RegistrationViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//  Copyright © 2025 Boles. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CombineSchedulers

class RegistrationViewModel: ObservableObject {
    @Published private(set) var canSubmit: Bool = false
    
    @Published var emailAddress: String = ""
    @Published var password: String = ""
    
    @Published var emailAddressState: ValidatedState = .empty
    @Published var passwordState: ValidatedState = .empty
    
    // MARK: - Init
    
    init(factory: DebouncedValidationPublisherFactory = DebouncedValidationPublisherFactory(scheduler: .main)) {
        factory.createPublisher($emailAddress,
                                validator: EmailAddressValidator())
            .assign(to: &$emailAddressState)
        
        factory.createPublisher($password,
                                validator: PasswordValidator())
        .assign(to: &$passwordState)
        
        Publishers.CombineLatest($emailAddressState,
                                 $passwordState)
        .map { emailAddressState, passwordState in
            emailAddressState.isValid &&
            passwordState.isValid
        }
        .removeDuplicates()
        .receive(on: RunLoop.main)
        .assign(to: &$canSubmit)
    }
}
