//
//  ListItemView.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 7/10/24.
//
import UIKit
import SwiftUI
import SwiftData

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ListItemView: View {
    var connection: Connection
    var path: String
    var items: [Item]
    
    
    var body: some View {
        List {
            ForEach(items) { item in
                if item.type == .directory {
                    NavigationLink(destination: SearcheableListContentView(
                        connection: connection,
                        path: item.path)
                    ) {
                        ItemView(item: item)
                    }
                } else {
                    DownloableItemView(item: item, connection: connection)
                }
                
            }
        }.listStyle(PlainListStyle())
    }
}

struct DownloableItemView: View {
    var item: Item
    var connection: Connection
    @EnvironmentObject private var connectionService: ConnectionService
    
    @State private var showShareSheet = false
    @State private var fileURL: URL?
    @State private var isDownloading: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        ItemView(item: item, loading: isDownloading).onTapGesture {
            if item.type != .directory {
                isDownloading = true
                Task {
                    do {
                        let data = try await connectionService.downloadItem(path: item.path, conn: connection)
                        
                        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(item.name)
                        
                        try data.write(to: tempURL)
                        fileURL = tempURL
                        showShareSheet = true
                        
                    } catch {
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let fileURL = fileURL {
                ShareSheet(items: [fileURL])
            }
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage))
        }
    }
}

struct ItemView: View {
    var item: Item
    var loading: Bool?
    
    
    var body: some View {
        HStack {
            Image(systemName: icon(for: item.type))
                .foregroundColor(color(for: item.type))
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.path)
                    .font(.subheadline)
            }
            
            if let isLoading = loading {
                if isLoading {
                    ProgressView() // Muestra un indicador de carga
                }
            }
        }
    }
    
    private func icon(for type: ItemType) -> String {
        switch type {
        case .directory:
            return "folder"
        case .file:
            return "doc.text"
        case .binary:
            return "gear"
        }
    }
    
    // Función que selecciona el color adecuado
    private func color(for type: ItemType) -> Color {
        switch type {
        case .directory:
            return .blue
        case .file:
            return .gray
        case .binary:
            return .orange
        }
    }
}

#Preview {
    
    ListItemView(
        connection: Connection(
            name: "dev",
            host: URL(string:"ftp://127.0.0.1")!,
            username: "dev",
            password: "dev"
        ),
        path: "/",
        items: Item.previews
    )
}
