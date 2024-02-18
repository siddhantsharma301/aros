//
//  RequestManager.swift
//  Aros
//
//  Created by Anjan Bharadwaj on 2/17/24.
//

import Foundation

func postPubKeyRequest(userId: String, pubKey: String) {
    guard let url = URL(string: "https://aros-dashboard.vercel.app/api/post-pubkey") else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let requestBody = PublicKey(userId: userId, pubKey: pubKey)
    guard let requestData = try? JSONEncoder().encode(requestBody) else { return }
    request.httpBody = requestData
    print(request)
    
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        
        print(data)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            // Check for the HTTP status code
//            if let responseData = try? JSONDecoder().decode(YourResponseData.self, from: data) {
//                // Handle your response data here
//                DispatchQueue.main.async {
//                    // Update your UI here based on the response
//                }
//            }
        } else {
            print("Error: HTTP request failed")
        }
    }.resume()
}

//func usernameExists(userId: String)  async throws -> Bool {
//    guard let url = URL(string: "https://aros-dashboard.vercel.app/api/check-username") else { return false }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//    let requestBody = Username(userId: userId)
//    guard let requestData = try? JSONEncoder().encode(requestBody) else { return false }
//    request.httpBody = requestData
//    print(request)
//    
//    
//    URLSession.shared.dataTask(with: request) { data, response, error in
//        guard let data = data, error == nil else {
//            print(error?.localizedDescription ?? "No data")
//            return false
//        }
//        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
//            return true
//        } else {
//            print("username exists")
//            return false
//        }
//    }.resume()
//}
