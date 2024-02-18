//
//  LoadingView.swift
//  Aros
//
//  Created by Megha Jain on 2/17/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var progress = 0.0
    @State private var currentStep = 0
    @State private var timer: Timer?
    
    let steps = ["Hashing Image", "Signing to Hardware", "Committing to Registry"]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(steps[currentStep])
                    .font(.title)
                    .foregroundColor(.white)
                
                ProgressView(value: progress, total: 100)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .onAppear {
                        startProgress()
                    }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
        }
    }
    
    func startProgress() {
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if progress < 100 {
                progress += 5
            } else {
                timer?.invalidate()
                if currentStep < steps.count - 1 {
                    currentStep += 1
                    startProgress()
                }
            }
        }
    }
}

#Preview {
    LoadingView()
}
