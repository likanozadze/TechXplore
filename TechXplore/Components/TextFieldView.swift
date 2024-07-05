//
//  TextFieldView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI
 
struct TextFieldView: View {
    
    // MARK: - Properties
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(.darkgray)
                .fontWeight(.semibold)
                .font(.footnote)
        
            
            if isSecureField {
                SecureField("", text: $text, prompt: Text(placeholder)
                    .foregroundColor(.gray))
                    .font(.system(size: 14))
            } else {
                TextField("", text: $text, prompt: Text(placeholder)
                    .foregroundColor(.gray)
                )
                    .font(.system(size: 14))
            }
            Divider()
            
        }
    }
    
}

 
// MARK: - Preview
#Preview {
    TextFieldView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
}
