//
//  ConnectFormView.swift
//  Faitp
//
//  Created by Edu Pazmiño Peralta on 30/9/24.
//

import SwiftUI
import SwiftData
import FilesProvider

struct ConnectFormView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject private var connectionService: ConnectionService
    
    //    @ObservedObject var viewModel: ContentItemListViewModel
    @State var credentails: FTPCredentials = FTPCredentials(host: "ftp://127.0.0.1", username: "dev", password: "dev")
    @State private var showAlert = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section() {
                    TextField("Host", text: $credentails.host).textCase(.none)
                    TextField("Username", text: $credentails.username).textCase(.none)
                    SecureField("Password", text: $credentails.password).textCase(.none)
                    Button(action: {
                        Task {
                            do {
                                try await connectionService.connect(credentials: credentails)
                                presentationMode.wrappedValue.dismiss()
                            } catch let err {
                                errorMessage = err.localizedDescription
                                showAlert = true
                            }
                        }
                    }) {
                        HStack {
                            Text("Connect")
                            if isLoading { // 4. Mostrar ProgressView si isLoading es true
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
                }
                //            NavigationLink(destination: ListContentView(viewModel: viewModel))
            }
            .navigationTitle("Create connection")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage)
                )
            }
        }
    }
}


#Preview {
    let mockContainer: ModelContainer = {
        let schema = Schema([
            Connection.self,
            Item.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Error creating mock container: \(error)")
        }
    }()
    
    let mockService = ConnectionService(model: mockContainer.mainContext)
    
    ConnectFormView()
        .modelContainer(for: Connection.self, inMemory: true)
        .modelContainer(for: Item.self, inMemory: true)
        .environmentObject(mockService)
}
