//
//  RegistrationViewModel.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//  Copyright © 2025 Boles. All rights reserved.
//

import Foundation
import Combine

class RegistrationViewModel: ObservableObject {
    @Published private(set) var canSubmit = false
    
    let emailAddressViewModel = ValidatedFieldViewModel(title: "Email Address",
                                                        placeholder: "Enter email address",
                                                        validator: EmailAddressValidator())
    
    let passwordViewModel = ValidatedFieldViewModel(title: "Password",
                                                    placeholder: "Enter password",
                                                    instructions: "Password must: \n - Be between 8 and 24 characters in length. \n - Contain a lower case letter. \n - Contain an upper case letter. \n - Contain a specical symbol from: \"&, _, -, @\".",
                                                    isSecure: true,
                                                    validator: PasswordValidator())
    
    // MARK: - Init
    
    init() {
        Publishers.CombineLatest(emailAddressViewModel.$state, passwordViewModel.$state)
        .map { emailAddressState, passwordState in
            emailAddressState.isValid &&
            passwordState.isValid
        }
        .removeDuplicates()
        .receive(on: RunLoop.main)
        .assign(to: &$canSubmit)
    }
}
