//
//  ListContentView.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 1/10/24.
//

import SwiftUI
import SwiftData

struct ListContentView: View {
    var connection: Connection
    var path: String?
    @State private var searchText: String = "" // Variable para el texto de búsqueda
    @Query() private var items: [Item]
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
                TextField("Search...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding()
            
            DynamicListItemView(
                connection: connection,
                searchText: searchText
            )
        }
        .navigationTitle(path ?? "")
    }
}

struct DynamicListItemView: View {
    private var connection: Connection
    @Query() private var items: [Item]
    
    init(connection:Connection, searchText: String) {
        self.connection = connection
        
        _items = Query(filter: #Predicate<Item> {
            searchText.isEmpty || $0.name.localizedStandardContains(searchText)
        })
    }
    
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
        }.listStyle(PlainListStyle())
    }
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
    .modelContainer(Item.preview)
}
