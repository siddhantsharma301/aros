//
//  Username.swift
//  Aros
//
//  Created by Anjan Bharadwaj on 2/17/24.
//

import Foundation

struct JsonUsername: Codable {
    var userId: String
}

struct JsonPublicKey: Codable {
    var userId: String
    var pubKey: String
}

struct JsonHash: Codable {
    var hash: String
}
