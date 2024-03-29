//
//  RequestManager.swift
//  Aros
//
//  Created by Anjan Bharadwaj on 2/17/24.
//

import Foundation

func postPubKeyRequest(userId: String, pubKey: String, completion: @escaping (Result<Bool, Error>) -> Void) {
    guard let url = URL(string: "https://aros-dashboard.vercel.app/api/post-pubkey") else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let requestBody = JsonPublicKey(userId: userId, pubKey: pubKey)
    guard let requestData = try? JSONEncoder().encode(requestBody) else { return }
    request.httpBody = requestData
    print(request)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 400 else {
            // Handle non-200 responses explicitly if needed, or generalize error handling
            completion(.failure(URLError(.badServerResponse)))
            return
        }

        do {
            // Assuming the response JSON structure is known and matches ResponseData
            let jsonData = try JSONDecoder().decode(ResponseData.self, from: data)
            if jsonData.success {
                // If the JSON response contains "success: true"
                completion(.success(true))
            } else {
                // If "success" is present but not true, or any other case
                completion(.success(false))
            }
        } catch {
            completion(.failure(error))
        }
    }.resume()
    
}

func getPubKeySigForHashRequest(hash: String, completion: @escaping (Result<(Data, Data), Error>) -> Void) {
    guard let url = URL(string: "https://aros-dashboard.vercel.app/api/get-signature") else {
        completion(.failure(URLError(.badURL)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let requestBody = JsonHash(hash: hash)  // Ensure JsonHash is properly defined to be encodable
    do {
        let requestData = try JSONEncoder().encode(requestBody)
        request.httpBody = requestData
    } catch {
        completion(.failure(error))
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let signatureString = json["signature"] as? String,
               let pubKeyString = json["pubKey"] as? String,
               let signatureData = Data(base64Encoded: signatureString),
               let pubKeyData = Data(base64Encoded: pubKeyString) {
                completion(.success((pubKeyData, signatureData)))
            } else {
                completion(.failure(URLError(.cannotDecodeContentData)))
            }
        } catch {
            completion(.failure(error))
        }
    }.resume()
}


//posts an image, consisting of hash, signature, and corresponding public key to verify
func postHashPubKeySig(hash: String, pubKey: String, signature: String, completion: @escaping (Result<Bool, Error>) -> Void) {
    guard let url = URL(string: "https://aros-dashboard.vercel.app/api/post-image") else {
        completion(.failure(URLError(.badURL)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let requestBody = JsonHashPubKeySig(hash: hash, pubKey: pubKey, signature: signature)  // Ensure JsonHashPubKeySig is properly defined to be encodable
    do {
        let requestData = try JSONEncoder().encode(requestBody)
        request.httpBody = requestData
    } catch {
        completion(.failure(error))
        return 
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        completion(.success(true))

        
    }.resume()
}
