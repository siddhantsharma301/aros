//
//  ArosApp.swift
//  Aros
//
//  Created by Maanav Khaitan on 2/16/24.
//

import SwiftUI
import Security

@main
struct ArosApp: App {
    init() {
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
                kSecAttrLabel as String:           "com.example.myapp.privatekey"
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
            print("Public Key: \(publicKeyData as NSData)")
        } else {
            print("Failed to extract public key for logging.")
        }
        UINavigationBar.applyCustomAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

fileprivate extension UINavigationBar {
    
    static func applyCustomAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
