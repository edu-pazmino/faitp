//
//  Connection.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 1/10/24.
//

import Foundation
import SwiftData

@Model
final class Connection {
    var name: String
    var host: URL
    var username: String
    var password: String
    
    init(name: String, host: URL, username: String, password: String) {
        self.name = name
        self.host = host
        self.username = username
        self.password = password
    }
}
