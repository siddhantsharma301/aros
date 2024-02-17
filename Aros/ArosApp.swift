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
                    print("Public Key: \(publicKeyData.base64EncodedString())")
                } else {
                    print("Failed to extract public key for logging.")
                }
            } else {
                // Key already exists, proceed with your logic, e.g., retrieving the key.
                print("Key pair already exists.")
            }
        UINavigationBar.applyCustomAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func retrievePrivateKey() -> SecKey? {
        let query: [String: Any] = [
            kSecClass as String:               kSecClassKey,
            kSecAttrKeyType as String:         kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrTokenID as String:         kSecAttrTokenIDSecureEnclave,
            kSecAttrLabel as String:           "com.example.myapp.privatekey",
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

fileprivate extension UINavigationBar {
    
    static func applyCustomAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
