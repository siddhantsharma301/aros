//
//  ContentView.swift
//  Aros
//
//  Created by Maanav Khaitan on 2/16/24.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) { // Adjust the spacing as needed
                Image("aroslogo") // The name of the image in your asset catalog
                    .resizable() // Make the image resizable
                    .scaledToFit() // Scale the image to fit its container
                    .frame(width: 150, height: 150) // Specify the size of the image
                
                Text("Aros")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: CameraView()) {
                    Text("Go to Camera")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding() // Add padding around the VStack content
        }
    }
}
