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
    var path: String
    
    @ObservedObject private var model = SearchViewModel()
    @Query() private var items: [Item]
    @EnvironmentObject private var connectionService: ConnectionService
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            if (isLoading) {
                ProgressView()
            } else {
                DynamicListItemView(
                    connection: connection,
                    searchText: model.searchText,
                    path: path
                )
            }
        }
        .searchable(text: $model.searchText, placement: .navigationBarDrawer)
        .navigationTitle(path)
        .onAppear() {
            guard !isLoading else { return }
            Task {
                do {
                    isLoading = true
                    try await connectionService.readFilesFrom(path: path, conn: connection)
                    isLoading = false
                } catch let err {
                    isLoading = false
                    errorMessage = err.localizedDescription
                    print(err)
                    
                }
            }
        }
    }
}

struct InputSearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
            
            TextField("Search...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }.padding()
    }
}

struct DynamicListItemView: View {
    private var connection: Connection
    var path: String
    @Query() private var items: [Item]
    
    /// Inicializa una nueva instancia.
    ///
    /// Este inicializador configura la conexión y realiza una consulta
    /// reactiva basada en el texto de búsqueda proporcionado. He aprendido
    /// que el código es reactivo y que se renderiza cada vez que hay un
    /// cambio en las variables, similar a cómo funciona React.
    ///
    /// - Parameters:
    ///   - connection: La conexión utilizada para interactuar con la base de datos.
    ///   - searchText: El texto utilizado para filtrar los elementos.
    init(connection:Connection, searchText: String, path: String) {
        self.connection = connection
        self.path = path
        
        let filterPredicate = #Predicate<Item> {
            (searchText.isEmpty || $0.name.localizedStandardContains(searchText)) && $0.parentPath == path
        }
        
        _items = Query(filter: filterPredicate)
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink (destination: ListContentView(
                    connection: connection,
                    path: item.path)
                ) {
                    ItemView(item: item)
                }
                
            }
        }.listStyle(PlainListStyle())
    }
}

struct ItemView: View {
    var item: Item
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.headline)
            Text(item.path)
                .font(.subheadline)
        }
    }
}

#Preview {
    ListContentView(
        connection: Connection(
            name: "dev",
            host: URL(string:"ftp://127.0.0.1")!,
            username: "dev",
            password: "dev"
        ),
        path: "/"
    )
    .modelContainer(Item.preview)
}
