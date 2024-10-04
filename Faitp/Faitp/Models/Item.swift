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
    var name: String
    var path: String
    var url: URL
    
    init(name: String, path: String, url: URL) {
        self.name = name
        self.path = path
        self.url = url
    }
    
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        // Directorios del sistema
        container.mainContext.insert(Item(name: "Bin", path: "/bin", url: URL(string: "https://example.com/bin")!))
        container.mainContext.insert(Item(name: "Usr", path: "/usr", url: URL(string: "https://example.com/usr")!))
        container.mainContext.insert(Item(name: "Lib", path: "/lib", url: URL(string: "https://example.com/lib")!))
        container.mainContext.insert(Item(name: "Etc", path: "/etc", url: URL(string: "https://example.com/etc")!))
        container.mainContext.insert(Item(name: "Opt", path: "/opt", url: URL(string: "https://example.com/opt")!))
        
        // Archivos en los directorios
        container.mainContext.insert(Item(name: "bash", path: "/bin/bash", url: URL(string: "https://example.com/bin/bash")!))
        container.mainContext.insert(Item(name: "ls", path: "/bin/ls", url: URL(string: "https://example.com/bin/ls")!))
        container.mainContext.insert(Item(name: "vim", path: "/usr/bin/vim", url: URL(string: "https://example.com/usr/bin/vim")!))
        container.mainContext.insert(Item(name: "config", path: "/etc/config", url: URL(string: "https://example.com/etc/config")!))
        container.mainContext.insert(Item(name: "nginx.conf", path: "/etc/nginx/nginx.conf", url: URL(string: "https://example.com/etc/nginx/nginx.conf")!))
        
        // Documentos en el directorio del usuario
        container.mainContext.insert(Item(name: "README.md", path: "/home/user/README.md", url: URL(string: "https://example.com/home/user/README.md")!))
        container.mainContext.insert(Item(name: "project.zip", path: "/home/user/project.zip", url: URL(string: "https://example.com/home/user/project.zip")!))
        container.mainContext.insert(Item(name: "report.pdf", path: "/home/user/documents/report.pdf", url: URL(string: "https://example.com/home/user/documents/report.pdf")!))
        return container
    }
}
