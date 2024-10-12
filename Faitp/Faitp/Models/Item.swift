//
//  Item.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 29/9/24.
//

import Foundation
import SwiftData
import FilesProvider

enum ItemType: String, Codable, CaseIterable {
    case file
    case directory
    case binary
    
}

@Model
final class Item {
    var parentPath: String
    var name: String
    var path: String
    var url: URL
    var hidden: Bool
    var type: ItemType
    var readonly: Bool
    
    var ftp: FTPFileProvider? {
        return connection?.toFTPCredentials().toFTPFileProvider()
    }
    
    var connection: Connection?
    
    init(parentPath: String, name: String, path: String, url: URL, connection: Connection?, type: ItemType = .file, hidden: Bool = false, readonly: Bool = false) {
        self.parentPath = parentPath
        self.name = name
        self.path = path
        self.url = url
        self.connection = connection
        self.type = type
        self.hidden = hidden
        self.readonly = readonly
    }
    
    
    func download(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let ftp = self.ftp else {
            completion(.failure(NSError(domain: "FTPError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No FTP connection available."])))
            return
        }
        print("downloading \(path)")
        
        ftp.contents(path: path) { result, error  in
            if let err = error {
                completion(.failure(err))
            } else if let data = result {
                completion(.success(data))
            }
        }
    }
    
    
    static func from(parentPath: String, connection: Connection, file: FileObject) -> Item {
        let name = file.name
        let path = file.path
        let url = file.url
        let hidden = file.isHidden
        let readonly = file.isReadOnly
        
        // Determinar el tipo de `Item` basado en el tipo de `FileObject`
        let type: ItemType
        switch file.type {
        case .directory:
            type = .directory
        case .regular:
            type = .file
        default:
            type = .binary
        }
        
        return Item(
            parentPath: parentPath,
            name: name,
            path: path,
            url: url,
            connection: connection,
            type: type,
            hidden: hidden,
            readonly: readonly
        )
    }
    
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        // Crear una conexión de ejemplo
        let connection = Connection(name: "Example Connection", host: URL(string: "https://example.com")!, username: "user", password: "password")
        
        // Directorios del sistema asociados con la conexión
        container.mainContext.insert(Item(parentPath: "/", name: "Bin", path: "/bin", url: URL(string: "https://example.com/bin")!, connection: connection, type: .directory))
        container.mainContext.insert(Item(parentPath: "/", name: "Usr", path: "/usr", url: URL(string: "https://example.com/usr")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/", name: "Lib", path: "/lib", url: URL(string: "https://example.com/lib")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/", name: "Etc", path: "/etc", url: URL(string: "https://example.com/etc")!, connection: connection, type: .directory))
        container.mainContext.insert(Item(parentPath: "/", name: "Opt", path: "/opt", url: URL(string: "https://example.com/opt")!, connection: connection))
        
        // Archivos en los directorios asociados con la conexión
        container.mainContext.insert(Item(parentPath: "/bin", name: "bash", path: "/bin/bash", url: URL(string: "https://example.com/bin/bash")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/bin", name: "ls", path: "/bin/ls", url: URL(string: "https://example.com/bin/ls")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/usr/bin", name: "vim", path: "/usr/bin/vim", url: URL(string: "https://example.com/usr/bin/vim")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/etc", name: "config", path: "/etc/config", url: URL(string: "https://example.com/etc/config")!, connection: connection))
        container.mainContext.insert(Item(parentPath: "/etc/nginx", name: "nginx.conf", path: "/etc/nginx/nginx.conf", url: URL(string: "https://example.com/etc/nginx/nginx.conf")!, connection: connection))
        
        return container
    }
    
    @MainActor
    static var previews: [Item] {
        // Crear una conexión de ejemplo
        let connection = Connection(name: "Example Connection", host: URL(string: "https://example.com")!, username: "user", password: "password")
        
        
        return [
            // Directorios del sistema asociados con la conexión
            Item(parentPath: "/", name: "Bin", path: "/bin", url: URL(string: "https://example.com/bin")!, connection: connection, type: .directory),
            Item(parentPath: "/", name: "Usr", path: "/usr", url: URL(string: "https://example.com/usr")!, connection: connection),
            Item(parentPath: "/", name: "Lib", path: "/lib", url: URL(string: "https://example.com/lib")!, connection: connection),
            Item(parentPath: "/", name: "Etc", path: "/etc", url: URL(string: "https://example.com/etc")!, connection: connection, type: .directory),
            Item(parentPath: "/", name: "Opt", path: "/opt", url: URL(string: "https://example.com/opt")!, connection: connection),
            
            // Archivos en los directorios asociados con la conexión
            Item(parentPath: "/bin", name: "bash", path: "/bin/bash", url: URL(string: "https://example.com/bin/bash")!, connection: connection),
            Item(parentPath: "/bin", name: "ls", path: "/bin/ls", url: URL(string: "https://example.com/bin/ls")!, connection: connection),
            Item(parentPath: "/usr/bin", name: "vim", path: "/usr/bin/vim", url: URL(string: "https://example.com/usr/bin/vim")!, connection: connection),
            Item(parentPath: "/etc", name: "config", path: "/etc/config", url: URL(string: "https://example.com/etc/config")!, connection: connection),
            Item(parentPath: "/etc/nginx", name: "nginx.conf", path: "/etc/nginx/nginx.conf", url: URL(string: "https://example.com/etc/nginx/nginx.conf")!, connection: connection)
        ]
    }
}
