//
//  LoadingView.swift
//  Aros
//
//  Created by Megha Jain on 2/17/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var progress: Double = 0.0
    @Binding private var currentStep: Int
    @Binding var isShowing: Bool
    
    private let steps = ["Hashing Image", "Signing to Hardware", "Committing to Registry"]
    private let totalSteps: Int
    
    init(isShowing: Binding<Bool>, currentStep: Binding<Int>) {
        _isShowing = isShowing
        _currentStep = currentStep
        self.totalSteps = steps.count
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
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.progress < 100.0 {
                self.progress += 10.0
            } else {
                if self.currentStep < self.totalSteps - 1 {
                    self.currentStep+=1
                    self.progress = 0.0
                } else {
                    timer.invalidate()
                    self.isShowing = false
                }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    @State static var isShowingPreview = true
    @State static var currentStepPreview = 0
    
    static var previews: some View {
        LoadingView(isShowing: $isShowingPreview, currentStep: $currentStepPreview)
    }
}
