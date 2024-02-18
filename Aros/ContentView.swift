//
//  ContentView.swift
//  Aros
//
//  Created by Maanav Khaitan on 2/16/24.
//
import SwiftUI
import AudioToolbox
import UIKit


struct ContentView: View {
    @State private var navigate = false
    
    // has the user already signed in before? / do they already have a key?
    @State private var notFirstTime = false
    
    // State to manage the visibility of the success message
    @State private var showSuccessMessage = false
    // State to manage navigation
    @State private var navigateToNextPage = false
    
    @State private var navigateMessage = "Keys successfully generated."
    
    @State private var username: String = ""
    
    init() {
        notFirstTime = privateKeyExists()
        if (notFirstTime) {
            navigateToNextPage = true
        }
        print("init")
        print(navigateToNextPage)
    }
    
    func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func repeatVibration(numberOfTimes: Int, interval: TimeInterval) {
        guard numberOfTimes > 0 else { return }

        // Trigger initial vibration
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            // Recursive call to create a chain of vibrations
            repeatVibration(numberOfTimes: numberOfTimes - 1, interval: interval)
        }
    }
    
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
                
                TextField("Enter username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 50)
                
                
                Button(action: {
                        // Your onClick action here
                        // TODO (anjan): upload (username, public key) to registry
                        print("Key being generated")
                        
                        if retrievePrivateKey() == nil {
                            // Key does not exist, so create it.
                            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                                                kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                                                [.privateKeyUsage, .biometryAny], nil)!
                            let attributes: [String: Any] = [
                                kSecAttrKeyType as String:            kSecAttrKeyTypeECSECPrimeRandom,
                                kSecAttrKeySizeInBits as String:      256,
                                kSecAttrTokenID as String:            kSecAttrTokenIDSecureEnclave,
                                kSecPrivateKeyAttrs as String: [
                                    kSecAttrIsPermanent as String:    true,
                                    kSecAttrAccessControl as String:   accessControl,
                                    kSecAttrLabel as String:           "com.aros.privatekey"
                                ]
                            ]

                            var error: Unmanaged<CFError>?
                            guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
                                print("Error creating key: \((error!.takeRetainedValue() as Error).localizedDescription)")
                                return
                            }

                            guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
                                print("Error retrieving public key")
                                return
                            }

                            if let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? {
                                print("Public Key: \(publicKeyData.base64EncodedString())")
                            } else {
                                print("Failed to extract public key for logging.")
                            }
                        } else {
                            // Key already exists, proceed with your logic, e.g., retrieving the key.
                            print("Key pair already exists.")
                            navigateMessage = "Key pair already exists."
                        }
                    
                        showSuccessMessage = true
                                        
                        // Wait for 1.5 seconds, then navigate
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            navigateToNextPage = true
                        }
                    
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                        
                    }
    
                ) {
                        Text("Generate Key in Secure Enclave")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        
                    }.disabled(username.isEmpty)
                    
                    if showSuccessMessage {
                        Text(navigateMessage)
                    }
                
                    // Invisible NavigationLink
                    NavigationLink(destination: CameraView(), isActive: $navigateToNextPage) {
                        EmptyView()
                    }
                
            }
            .buttonStyle(PlainButtonStyle())
            .padding() // Add padding around the VStack content
        }
    }
    
    func privateKeyExists() -> Bool {
        let query: [String: Any] = [
            kSecClass as String:               kSecClassKey,
            kSecAttrKeyType as String:         kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrTokenID as String:         kSecAttrTokenIDSecureEnclave,
            kSecAttrLabel as String:           "com.aros.privatekey",
            kSecReturnRef as String:           true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess {
            print("true")
            return true
        } else {
            print("false")
            // Handle error (e.g., key not found)
            return false
        }
    }
    
    func retrievePrivateKey() -> SecKey? {
        let query: [String: Any] = [
            kSecClass as String:               kSecClassKey,
            kSecAttrKeyType as String:         kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrTokenID as String:         kSecAttrTokenIDSecureEnclave,
            kSecAttrLabel as String:           "com.aros.privatekey",
            kSecReturnRef as String:           true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess {
            return (item as! SecKey)
        } else {
            // Handle error (e.g., key not found)
            print("Error retrieving private key: \(status)")
            return nil
        }
    }
    
    
}
