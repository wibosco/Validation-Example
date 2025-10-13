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
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading,
                       spacing: 6) {
                    Text("Email Address")
                        .styleAsInputFieldTitle()

                    TextField("Enter your email address",
                              text: $viewModel.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .styleAsInputField()
                        .validated(viewModel.emailAddressState)
                }
                
                VStack(alignment: .leading,
                       spacing: 6) {
                    Text("Password")
                        .styleAsInputFieldTitle()
                    
                    SecureField("Enter your password",
                                text: $viewModel.password)
                        .styleAsInputField()
                        .validated(viewModel.passwordState)
                    
                    HStack(alignment: .top,
                           spacing: 4) {
                        Image(systemName: "info.circle")
                            .font(.caption)

                        Text("Password must: \n - Be between 8 and 24 characters in length. \n - Contain a lower case letter. \n - Contain an upper case letter. \n - Contain a specical symbol from: \"&, _, -, @\".")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Submit") {
                    if viewModel.canSubmit {
                        // Omitted submission code
                    } else {
                        // Omitted alert code
                    }
                }
            }
            .padding()
            .navigationTitle("Registration")
        }
    }
}

extension View {
    func styleAsInputField() -> some View {
        self
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
    
    func styleAsInputFieldTitle() -> some View {
        self
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.primary)
    }
}

extension View {
    func validated(_ state: ValidatedState) -> some View {
        VStack(alignment: .leading,
               spacing: 6) {
            self
                .border(state.isInvalid ? Color.red : Color.clear, width: 2)
            
            if case let .invalid(errorMessage) = state {
                HStack(alignment: .top,
                       spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.caption)
                    Text(errorMessage)
                        .font(.caption)
                }
                .foregroundColor(.red)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2),
                   value: state.isInvalid)
    }
}

#Preview {
    let viewModel = RegistrationViewModel()
    RegistrationView(viewModel: viewModel)
}
