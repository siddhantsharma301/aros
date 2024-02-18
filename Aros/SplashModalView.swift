//
//  SplashModalView.swift
//  Aros
//
//  Created by Anjan Bharadwaj on 2/18/24.
//


import SwiftUI

struct SplashModalView: View {
    @Binding var showModal: Bool
    @Binding var navigateToNextPage: Bool
//    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Keys successfully generated.")
                .font(.headline)
                .padding()

            Button("Continue to camera") {
                // Action for continue button
                print("Continue tapped")
//                presentationMode.wrappedValue.dismiss()
                showModal = false
                navigateToNextPage = true
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

struct SplashModalViewFail: View {
    @Binding var showModal: Bool
    @Binding var navigateToNextPage: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Keys were not created.")
                .font(.headline)
                
                .padding()

            Button("Return") {
                // Action for continue button
                print("Continue tapped")
                showModal = false
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
