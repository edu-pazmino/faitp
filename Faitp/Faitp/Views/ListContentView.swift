//
//  ListContentView.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 1/10/24.
//

import SwiftUI

struct ListContentView: View {
//    @EnvironmentObject var viewModel: ContentItemListViewModel
    
    var body: some View {
        VStack {
            Text("Hello world!")
//            ForEach(viewModel.contentItems) { item in
//                NavigationLink {
//                    Text("Item at \(item.name)")
//                } label: {
//                    Text(item.name)
//                }
//            }
//            .onDelete(perform: deleteItems)
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
    ListContentView()
}
