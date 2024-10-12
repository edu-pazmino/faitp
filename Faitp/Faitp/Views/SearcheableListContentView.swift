//
//  ListContentView.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 1/10/24.
//

import SwiftUI
import SwiftData

struct SearcheableListContentView: View {
    var connection: Connection
    var path: String
    
    @EnvironmentObject private var connectionService: ConnectionService
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @ObservedObject private var model = SearchViewModel()
    @Query() private var items: [Item]
    
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var showHiddenFiles: Bool = false
    
    
    var body: some View {
        VStack {
            Toggle("Mostrar archivos ocultos", isOn: $showHiddenFiles)
                .padding()
            
            if (isLoading) {
                ProgressView()
            } else {
                DynamicListItemView(
                    connection: connection,
                    searchText: model.searchText,
                    path: path,
                    showHiddenElements: showHiddenFiles
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
                    showError = true
                    print(err)
                    
                }
            }
        }.alert("Error", isPresented: $showError, actions: {
            Button("OK", role: .cancel) {
                showError = false
                presentationMode.wrappedValue.dismiss()
            }
        }, message: {
            Text(errorMessage)
        })
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
    init(connection:Connection, searchText: String, path: String, showHiddenElements: Bool) {
        self.connection = connection
        self.path = path
        
        let filterPredicate = #Predicate<Item> {
            ((searchText.isEmpty || $0.name.localizedStandardContains(searchText)) && $0.parentPath == path) && (showHiddenElements || !$0.hidden)
        }
        
        _items = Query(filter: filterPredicate)
    }
    
    var body: some View {
        ListItemView(connection: connection, path: path, items: items)
    }
}
