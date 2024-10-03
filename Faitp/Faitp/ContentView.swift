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
    @Query private var items: [Connection]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(items) { item in
                        VStack {
                            NavigationLink(destination: ListContentView(connection: item)) {
                                Text(item.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Connections")
            .toolbar {
                NavigationLink(destination: ConnectFormView()) {
                    Text("Connect")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Connection.self, inMemory: true)
}
