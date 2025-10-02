//
//  ValidatedField.swift
//  Validation-Example
//
//  Created by William Boles on 29/09/2025.
//

import SwiftUI
import Combine

struct ValidatedField<V: Validator, S: Scheduler>: View {
    @ObservedObject var viewModel: ValidatedFieldViewModel<V, S>
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 6) {
            Text(viewModel.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Group {
                if viewModel.isSecure {
                    SecureField(viewModel.placeholder,
                                text: $viewModel.value)
                } else {
                    TextField(viewModel.placeholder,
                              text: $viewModel.value)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(viewModel.showError ? Color.red : Color.clear, lineWidth: 2)
            )
            
            if let error = viewModel.error {
                HStack(alignment: .top,
                       spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.caption)
                    Text(error.localizedDescription)
                        .font(.caption)
                }
                .foregroundColor(.red)
                .transition(.opacity)
            }
            
            if let instructions = viewModel.instructions {
                HStack(alignment: .top,
                       spacing: 4) {
                    Image(systemName: "info.circle")
                        .font(.caption)
                    
                    Text(instructions)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.showError)
    }
}
