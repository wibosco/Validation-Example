//
//  RegistrationView.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//  Copyright © 2025 Boles. All rights reserved.
//

import SwiftUI

struct RegistrationView: View {
    @Bindable var viewModel: RegistrationViewModel
    
    // MARK: - Views
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            field("Scenario 1: No input", vm: viewModel.emailAddressViewModel)
            field("Scenario 2: Valid input", vm: viewModel.emailAddressViewModel2)
            field("Scenario 3: Invalid input", vm: viewModel.passwordViewModel)
        }
        .padding(20)
    }
    
    @ViewBuilder
    private func field(_ scenario: String,
                       vm: AnyValidationViewModel<String>) -> some View {
        @Bindable var vm = vm
        
        VStack(alignment: .leading, spacing: 30) {
            Text(scenario)
                .font(.custom("Marker Felt", size: 24))
                      
              FormField(title: "Title",
                        placeholder: "Placeholder text",
                        value: $vm.value)
              .autocapitalization(.none)
                .validationState(vm.validationState)
        }
    }
}

#Preview {
    let emailAddressValidator = EmailAddressValidator()
    let passwordValidator = PasswordValidator()
    
    let emailAddressViewModel = DefaultValidationViewModel(validator: emailAddressValidator)
        .eraseToAnyValidationViewModel()
    
    let passwordViewModel = DefaultValidationViewModel(validator: passwordValidator)
        .eraseToAnyValidationViewModel()
    
    let viewModel = RegistrationViewModel(emailAddressViewModel: emailAddressViewModel,
                                          emailAddressViewModel2: emailAddressViewModel,
                                          passwordViewModel: passwordViewModel)
    
    RegistrationView(viewModel: viewModel)
}
