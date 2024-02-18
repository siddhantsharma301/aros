//
//  CameraView.swift
//  Aros
//
//  Created by Anjan Bharadwaj on 2/17/24.
//

import SwiftUI

struct CameraView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var model = DataModel()
    @State private var isShowingSheet = false
    @State private var currentTextIndex = 0
    @State private var texts = ["Hashing Image", "Signing via Secure Enclave", "Committing to Registry"]
 
    private static let barHeightFactor = 0.15

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ViewfinderView(image:  $model.viewfinderImage )
                    .overlay(alignment: .top) {
                        Color.black
                            .opacity(0.75)
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                    }
                    .overlay(alignment: .bottom) {
                        buttonsView()
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                            .background(.black.opacity(0.75))
                    }
                    .overlay(alignment: .center)  {
                        Color.clear
                            .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                            .accessibilityElement()
                            .accessibilityLabel("View Finder")
                            .accessibilityAddTraits([.isImage])
                    }
                    .background(.black)
            }
            .task {
                await model.camera.start()
                await model.loadPhotos()
                await model.loadThumbnail()
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
            .statusBar(hidden: true)
        }
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Spacer()
            
            NavigationLink {
                PhotoCollectionView(photoCollection: model.photoCollection)
                    .onAppear {
                        model.camera.isPreviewPaused = true
                    }
                    .onDisappear {
                        model.camera.isPreviewPaused = false
                    }
            } label: {
                Label {
                    Text("Gallery")
                } icon: {
                    ThumbnailView(image: model.thumbnailImage)
                }
            }
            
            Button {
                model.camera.takePhoto()
                self.isShowingSheet = true
                self.currentTextIndex = 0
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .sheet(isPresented: $isShowingSheet) {
                VStack {
                    ProgressView(value: Float(currentTextIndex) / Float(self.texts.count))
                        .frame(width: 256)
                    Text(texts[currentTextIndex])
                        .padding()
                }
                .onReceive(Timer.publish(every: 0.35, on: .main, in: .common).autoconnect()) { _ in
                    if currentTextIndex < texts.count - 1 {
                        currentTextIndex += 1
                    } else {
                        currentTextIndex += 1
                        self.isShowingSheet = false
                    }
                }
            }
            
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
}
