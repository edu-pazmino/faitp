//
//  ListItemView.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 7/10/24.
//
import SwiftUI
import SwiftData

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
                    ItemView(item: item)
                }
                
            }
        }.listStyle(PlainListStyle())
    }
}

struct ItemView: View {
    var item: Item
    
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
