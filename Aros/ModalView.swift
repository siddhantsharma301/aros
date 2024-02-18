//
//  ModalView.swift
//  Aros
//
//  Created by Anjan Bharadwaj on 2/17/24.
//

import SwiftUI

struct ModalView: View {
    var body: some View {
        Text("Keys successfully generated.")
    }
}

struct PartialModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Keys successfully generated.")
                .font(.headline)
                .padding()

            Button("Continue to camera") {
                // Action for continue button
                print("Continue tapped")
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 300, height: 200)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct PartialModalViewFail: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Keys were not created.")
                .font(.headline)
                
                .padding()

            Button("Return") {
                // Action for continue button
                print("Continue tapped")
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 300, height: 200)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}
