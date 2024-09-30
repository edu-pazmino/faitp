//
//  ConnectFormView.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 30/9/24.
//

import SwiftUI
import FilesProvider

struct ConnectFormView: View {
    @ObservedObject var viewModel: ContentItemListViewModel
    @State var credentails: FTPCredentials = FTPCredentials(host: "ftp://127.0.0.1", username: "dev", password: "dev")
    @State private var showAlert = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Connection")) {
                TextField("Host", text: $credentails.host).textCase(.none)
                TextField("Username", text: $credentails.username).textCase(.none)
                SecureField("Password", text: $credentails.password).textCase(.none)
                Button("Connect", action: connect)
            }
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage)
            )
        }
    }
    
    func connect() {
        let (host, username, password) = credentails.asCredentails()
        let credential = URLCredential(user: username, password: password, persistence: .forSession)
        if let ftp = FTPFileProvider(baseURL: host, mode: .passive, credential: credential) {
            ftp.contentsOfDirectory(path: "/") { contents, err in
                if let err = err {
                    errorMessage = err.localizedDescription
                    showAlert = true
                    return
                }
                
                for content in contents {
                    DispatchQueue.main.async {
                        viewModel.addItem(title: content.name)
                    }
                }
            }
        }
    }
}
