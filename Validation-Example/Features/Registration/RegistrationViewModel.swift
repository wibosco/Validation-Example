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
    let emailAddressViewModel = ValidatedFieldViewModel(title: "Email Address",
                                                        placeholder: "Enter email address",
                                                        validator: EmailAddressValidator())
    
    let passwordViewModel = ValidatedFieldViewModel(title: "Password",
                                                    placeholder: "Enter password",
                                                    instructions: "Passowrd must be: \n - Between 8 and 24 characters in length. \n - Contain a lower case letter. \n - Contain an upper case letter. \n - Contain a specical symbol from:  \"&, _, -, @\".",
                                                    isSecure: true,
                                                    validator: PasswordValidator())
    
    @Published var isFormValid = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init() {
        // Combine validation from both fields
        emailAddressViewModel.$validationResult
            .combineLatest(emailAddressViewModel.$value, passwordViewModel.$validationResult, passwordViewModel.$value)
            .map { usernameResult, usernameValue, passwordResult, passwordValue in
                // Both fields must be valid AND not empty
                usernameResult.isValid && !usernameValue.isEmpty &&
                passwordResult.isValid && !passwordValue.isEmpty
            }
            .assign(to: &$isFormValid)
    }
}
