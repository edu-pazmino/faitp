//
//  ContentItemListViewModel.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 30/9/24.
//
import SwiftUI
import SwiftData

class ContentItemListViewModel: ObservableObject {
    @Published var contentItems: [Item] = []
    
    func addItem(title: String) {
//        let newItem = Item(name: title, )
//        contentItems.append(newItem)
    }
    
    func deleteMany(offsets: IndexSet) {
        contentItems.remove(atOffsets: offsets)
    }
}
