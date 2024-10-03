//
//  ListContentView.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 1/10/24.
//

import SwiftUI
import SwiftData

struct ListContentView: View {
//    @EnvironmentObject var viewModel: ContentItemListViewModel
    var connection: Connection
    
    @Query var items: [Item]
    
    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink (destination: ListContentView(connection: connection)) {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.path)
                            .font(.subheadline)
                    }
                }
                
            }
        }
//#if os(macOS)
//        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
//#endif
//        .toolbar {
//#if os(iOS)
//            ToolbarItem(placement: .navigationBarTrailing) {
//                EditButton()
//            }
//#endif
//            ToolbarItem {
//                Button(action: addItem) {
//                    Label("Add Item", systemImage: "plus")
//                }
//            }
//        }
    }
    
//    private func addItem(title: String) {
//        withAnimation {
//            viewModel.addItem(title: title)
//        }
//        
//    }
//    
//    private func addItem() {
//        withAnimation {
//            viewModel.addItem(title: "Test")
//        }
//    }
//    
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            viewModel.deleteMany(offsets: offsets)
//        }
//    }
}

#Preview {
    ListContentView(
        connection: Connection(
            name: "dev",
            host: URL(string:"ftp://127.0.0.1")!,
            username: "dev",
            password: "dev"
        )
    )
    .modelContainer(for: Connection.self, inMemory: true)
    .modelContainer(for: Item.self, inMemory: true)
}
