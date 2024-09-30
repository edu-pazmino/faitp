//
//  ContentView.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 29/9/24.
//

import SwiftUI
import SwiftData
import FilesProvider



struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel: ContentItemListViewModel = ContentItemListViewModel()
    @Query private var items: [Item]
    @State private var host: String = "ftp://127.0.0.1"
    @State private var username: String = "dev"
    @State private var password: String = "dev"
    @State private var showAlert = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationSplitView {
            ConnectFormView(viewModel: viewModel)
            List {
                ForEach(viewModel.contentItems) { item in
                    NavigationLink {
                        Text("Item at \(item.name)")
                    } label: {
                        Text(item.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage)
            )
        }
    }
    
    private func connect() {
        let username = $username.wrappedValue.lowercased()
        let password = $password.wrappedValue.lowercased()
        let host = URL(string: $host.wrappedValue.lowercased())
        let credential = URLCredential(user: username, password: password, persistence: .forSession)
        if let ftp = FTPFileProvider(baseURL: host!, mode: .passive, credential: credential) {
            ftp.contentsOfDirectory(path: "/") { contents, err in
                if let err = err {
                    errorMessage = err.localizedDescription
                    showAlert = true
                    return
                }
                
                for content in contents {
                    DispatchQueue.main.async {
                        addItem(title: content.name)
                    }
                }
            }
        }
    }
    
    private func addItem(title: String) {
        withAnimation {
            let newItem = Item(name: title)
            modelContext.insert(newItem)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(name: "Test")
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
