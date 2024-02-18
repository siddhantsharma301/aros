//
//  LoadingView.swift
//  Aros
//
//  Created by Megha Jain on 2/17/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var progress: Double = 0.0
    @State private var currentStep: Int = 0
    @Binding var isShowing: Bool
    
    private let steps = ["Hashing Image", "Signing to Hardware", "Committing to Registry"]
    private let totalSteps: Int
    
    init(isShowing: Binding<Bool>) {
        _isShowing = isShowing
        totalSteps = steps.count
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            if isShowing {
                VStack {
                    Text(steps[currentStep])
                        .font(.title)
                        .foregroundColor(.white)
                    
                    ProgressView(value: progress, total: 100)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .onAppear {
                            startLoadingProcess()
                        }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
            }
        }
    }
    
    private func startLoadingProcess() {
        currentStep = 0
        progress = 0.0
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            if self.currentStep < self.totalSteps {
                self.progress = 100.0
                self.currentStep += 1
            } else {
                timer.invalidate()
                self.isShowing = false
            }
            self.progress = 0.0
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    @State static var isShowingPreview = true
    
    static var previews: some View {
        LoadingView(isShowing: $isShowingPreview)
    }
}

