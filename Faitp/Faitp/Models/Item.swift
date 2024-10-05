//
//  Item.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 29/9/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var parentPath: String
    var name: String
    var path: String
    var url: URL
    
    var connection: Connection?
    
    init(parentPath: String, name: String, path: String, url: URL, connection: Connection?) {
        self.parentPath = parentPath
        self.name = name
        self.path = path
        self.url = url
        self.connection = connection
    }
    
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        // Crear una conexión de ejemplo
        let connection = Connection(name: "Example Connection", host: URL(string: "https://example.com")!, username: "user", password: "password")
        
        // Directorios del sistema asociados con la conexión
        container.mainContext.insert(Item(parentPath: "/", name: "Bin", path: "/bin", url: URL(string: "https://example.com/bin")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/", name: "Usr", path: "/usr", url: URL(string: "https://example.com/usr")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/", name: "Lib", path: "/lib", url: URL(string: "https://example.com/lib")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/", name: "Etc", path: "/etc", url: URL(string: "https://example.com/etc")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/", name: "Opt", path: "/opt", url: URL(string: "https://example.com/opt")!, connection: connection))
        
        // Archivos en los directorios asociados con la conexión
        container.mainContext.insert(Item(parentPath: "/bin", name: "bash", path: "/bin/bash", url: URL(string: "https://example.com/bin/bash")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/bin", name: "ls", path: "/bin/ls", url: URL(string: "https://example.com/bin/ls")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/usr/bin", name: "vim", path: "/usr/bin/vim", url: URL(string: "https://example.com/usr/bin/vim")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/etc", name: "config", path: "/etc/config", url: URL(string: "https://example.com/etc/config")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/etc/nginx", name: "nginx.conf", path: "/etc/nginx/nginx.conf", url: URL(string: "https://example.com/etc/nginx/nginx.conf")!, connection: connection))
        
        return container
    }
}
