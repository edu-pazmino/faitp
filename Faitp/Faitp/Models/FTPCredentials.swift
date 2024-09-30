//
//  FTPCredentials.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 30/9/24.
//
import Foundation
import SwiftData

@Model
final class FTPCredentials {
    var host: String
    var username: String
    var password: String
    
    init(host: String, username: String, password: String) {
        self.host = host
        self.username = username
        self.password = password
    }
    
    func asCredentails() -> (URL,String, String) {
        return (
            URL(string: host.lowercased())!,
            username.lowercased(),
            password.lowercased()
        )
    }
}

