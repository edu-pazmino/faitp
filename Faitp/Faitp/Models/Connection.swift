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
    
    @Relationship(deleteRule: .cascade, inverse: \Item.connection)
    var items = [Item]()
    
    init(name: String, host: URL, username: String, password: String) {
        self.name = name
        self.host = host
        self.username = username
        self.password = password
    }
    
    static func fromFTPCredentials(credentials: FTPCredentials) -> Connection {
        Connection(
            name: "\(credentials.username)@\(credentials.host)",
            host: URL(string:credentials.host)!,
            username: credentials.username,
            password: credentials.password
        )
    }
    
    func toFTPCredentials() -> FTPCredentials {
        FTPCredentials(
            host: host.absoluteString,
            username: username,
            password: password
        )
    }
}
