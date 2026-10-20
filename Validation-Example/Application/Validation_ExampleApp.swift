//
//  ModelingFormChanges_ExampleApp.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//

import SwiftUI

@main
struct ModelingFormChanges_ExampleApp: App {
    @State private var viewModel: RegistrationViewModel
    
    // MARK: - Init
    
    init() {
        let emailAddressValidator = EmailAddressValidator()
        let passwordValidator = PasswordValidator()
        
        let emailAddressViewModel = DefaultValidationViewModel(validator: emailAddressValidator)
        
        let passwordViewModel = DefaultValidationViewModel(validator: passwordValidator)
        
        _viewModel = State(initialValue: RegistrationViewModel(emailAddressViewModel: emailAddressViewModel.eraseToAnyValidationViewModel(),
                                                               passwordViewModel: passwordViewModel.eraseToAnyValidationViewModel()))
    }
    
    // MARK: - Scene
    
    var body: some Scene {
        WindowGroup {
            RegistrationView(viewModel: viewModel)
        }
    }
}
