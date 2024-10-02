//
//  ConnectFormView.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 30/9/24.
//

import SwiftUI
import SwiftData
import FilesProvider

struct ConnectFormView: View {
    @Environment(\.modelContext) private var modelContext
    
    //    @ObservedObject var viewModel: ContentItemListViewModel
    @State var credentails: FTPCredentials = FTPCredentials(host: "ftp://127.0.0.1", username: "dev", password: "dev")
    @State private var showAlert = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    
    
    var body: some View {
        NavigationView {
            Form {
                Section() {
                    TextField("Host", text: $credentails.host).textCase(.none)
                    TextField("Username", text: $credentails.username).textCase(.none)
                    SecureField("Password", text: $credentails.password).textCase(.none)
                    NavigationLink(destination: ListContentView()) {
                        Button(action: {
                            Task {
                                await connect()
                            }
                        }) {
                            HStack {
                                Text("Connect")
                                if isLoading { // 4. Mostrar ProgressView si isLoading es true
                                    Spacer()
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
                //            NavigationLink(destination: ListContentView(viewModel: viewModel))
            }
            .navigationTitle("Create connection")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage)
                )
            }
        }
    }
    
    func connect() async -> Result<Void, Error> {
        await withCheckedContinuation { continuation in
            isLoading = true
            let (host, username, password) = credentails.asCredentails()
            
            let credential = URLCredential(user: username, password: password, persistence: .forSession)
            
            if let ftp = FTPFileProvider(baseURL: host, mode: .passive, credential: credential) {
                ftp.contentsOfDirectory(path: "/") { contents, err in
                    if let err = err {
                        errorMessage = err.localizedDescription
                        showAlert = true
                        continuation.resume(returning: .failure(err))
                        return
                    }
                    
                    let conn = Connection(
                        name: "\(username)@\(String(describing: host.baseURL))",
                        host: host,
                        username: username,
                        password: password
                    )
                    
                    let newItems = contents.map { content in Item(name: content.name, path: content.path, url: content.url) }
                    modelContext.insert(conn)
                    newItems.forEach { item in
                        modelContext.insert(item)
                    }
                    
                    do {
                        try modelContext.save()
                        continuation.resume(returning: .success(()))
                        isLoading = false
                    } catch {
                        
                    }
                    
                }
            }
        }
    }
}


#Preview {
    ConnectFormView()
        .modelContainer(for: Connection.self, inMemory: true)
        .modelContainer(for: Item.self, inMemory: true)
}
