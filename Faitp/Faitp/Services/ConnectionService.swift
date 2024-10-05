//
//  ConnectionService.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 5/10/24.
//
import SwiftData
import SwiftUICore
import FilesProvider

class ConnectionService: ObservableObject {
    private var model: ModelContext
    
    init(model: ModelContext) {
        self.model = model
    }
    
    
    func connect(credentials: FTPCredentials) async throws -> Void {
        return try await withCheckedThrowingContinuation { continuation in
            if let ftp = credentials.toFTPFileProvider() {
                let initialPath = "/"
                ftp.contentsOfDirectory(path: initialPath) { contents, err in
                    if let err = err {
                        continuation.resume(throwing: err)
                    }
                    do {
                        let conn = Connection.fromFTPCredentials(credentials: credentials)
                        self.model.insert(conn)
                        try self.model.save()
                        continuation.resume()
                    } catch let err {
                        continuation.resume(throwing: err)
                    }
                }
            } else {
                continuation.resume(throwing: NSError(domain: "ConnectionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not create FTP connection"]))
            }
        }
    }
    
    
    func readFilesFrom(path: String, conn: Connection) async throws -> Void {
        return try await withCheckedThrowingContinuation { continuation in
            let credentials = conn.toFTPCredentials()
            
            if let ftp = credentials.toFTPFileProvider() {
                ftp.contentsOfDirectory(path: path) { contents, err in
                    if let err = err {
                        continuation.resume(throwing: err)
                    }
                    
                    do {
                        //TODO: I need double check has connection exist into DB
                        let itemsToDelete = try self.model.fetch(FetchDescriptor<Item>(predicate: #Predicate<Item> {
                            $0.parentPath == path
                        }))
                        
                        // Elimina cada uno de los items de forma segura
                        for item in itemsToDelete {
                            self.model.delete(item)
                        }
                        self.readAllItems(path: path, contents: contents, conn: conn)
                        try self.model.save()
                        
                        continuation.resume()
                    } catch let err {
                        continuation.resume(throwing: err)
                    }
                }
            }
        }
    }
    
    
    private func readAllItems(path: String, contents: [FileObject], conn: Connection) -> Void {
        contents.forEach { content in
            self.model.insert(
                Item(
                    parentPath: path,
                    name: content.name,
                    path: content.path,
                    url: content.url,
                    connection: conn
                )
            )
        }
    }
}
