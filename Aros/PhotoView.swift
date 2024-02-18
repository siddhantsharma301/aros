//
//  PhotoView.swift
//  Aros
//
//  Created by Siddhant Sharma on 2/16/24.
//

import SwiftUI
import Photos
import CryptoKit

struct PhotoView: View {
    var asset: PhotoAsset
    var cache: CachedImageManager?
    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?
    @Environment(\.dismiss) var dismiss
    private let imageSize = CGSize(width: 1024, height: 1024)
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel(asset.accessibilityLabel)
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color.secondary)
        .navigationTitle("Photo")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            buttonsView()
                .offset(x: 0, y: -50)
        }
        .task {
            guard image == nil, let cache = cache else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result = result {
                        self.image = result.image
                    }
                }
            }
        }
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            Button {
                Task {
                    await asset.setIsFavorite(!asset.isFavorite)
                }
            } label: {
                Label("Favorite", systemImage: asset.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 24))
            }

            Button {
                Task {
                    await asset.delete()
                    await MainActor.run {
                        dismiss()
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
                    .font(.system(size: 24))
            }
            Button {
                Task {
                    imageData(for: asset) { data, error in
                        if let data = data {
                            // Use the image data, for example, to create a UIImage
                            let hashedData = hashImageData(photoData: data)
                            print("hashed data in library is \(hashedData)")
                        } else if let error = error {
                            // Handle the error
                            print("Error fetching image data: \(error.localizedDescription)")
                        }
                    }
//                    let hashedData = hashImageData(photoData: imageData)
                }
            } label: {
                Label("Verify", systemImage: "checkmark.shield")
                    .font(.system(size: 24))
            }
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
        .background(Color.secondary.colorInvert())
        .cornerRadius(15)
    }
    
    private func hashImageData(photoData: Data) -> SHA256Digest {
        let hash = SHA256.hash(data: photoData)
        return hash as SHA256Digest
    }
    
    private func imageData(for photoAsset: PhotoAsset, completion: @escaping (Data?, Error?) -> Void) {
        // Ensure that there is a PHAsset instance associated with the PhotoAsset
        guard let phAsset = photoAsset.phAsset else {
            completion(nil, NSError(domain: "PhotoAssetError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing PHAsset"]))
            return
        }

        // Options for the image data request
        let options = PHImageRequestOptions()
        options.version = .original // Request the original image data
        options.isSynchronous = false // Perform the request asynchronously
        options.deliveryMode = .highQualityFormat // Request the image in high quality

        // Request the image data
        PHImageManager.default().requestImageDataAndOrientation(for: phAsset, options: options) { imageData, dataUTI, orientation, info in
            // Check for errors in the info dictionary
            if let error = info?[PHImageErrorKey] as? Error {
                completion(nil, error)
                return
            }

            // Check if the request was cancelled
            if let cancelled = (info?[PHImageCancelledKey] as? NSNumber)?.boolValue, cancelled {
                completion(nil, NSError(domain: "PhotoAssetError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Request was cancelled"]))
                return
            }

            // Return the image data
            completion(imageData, nil)
        }
    }
}
