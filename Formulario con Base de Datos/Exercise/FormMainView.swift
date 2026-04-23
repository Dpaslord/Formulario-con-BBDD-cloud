import SwiftUI

struct FormMainView: View {
    
    @StateObject private var vm = FormViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                
                // MARK: - Formulario
                Section(header: Text("Formulario")) {
                    
                    // TÍTULO
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Título", text: $vm.titulo)
                            .overlay {
                                if !vm.titulo.isEmpty && !vm.isTituloValido {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.red, lineWidth: 1)
                                }
                            }
                        
                        if !vm.titulo.isEmpty && !vm.isTituloValido {
                            Text("Debe tener entre 5 y 60 caracteres")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // DESCRIPCIÓN
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Descripción", text: $vm.descripcion)
                            .overlay {
                                if !vm.descripcion.isEmpty && !vm.isDescripcionValida {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.red, lineWidth: 1)
                                }
                            }
                        
                        if !vm.descripcion.isEmpty && !vm.isDescripcionValida {
                            Text("Debe tener entre 20 y 500 caracteres")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // CATEGORÍA
                    TextField("Categoría", text: $vm.categoria)
                    
                    // PRIORIDAD
                    Stepper("Prioridad: \(vm.prioridad)", value: $vm.prioridad, in: 1...5)
                    
                    // EMAIL
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Email", text: $vm.email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .overlay {
                                if !vm.email.isEmpty && !vm.isEmailValido {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.red, lineWidth: 1)
                                }
                            }
                        
                        if !vm.email.isEmpty && !vm.isEmailValido {
                            Text("Introduce un email válido")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // BOTÓN
                    Button {
                        Task { await vm.enviar() }
                    } label: {
                        if vm.isLoading {
                            HStack {
                                ProgressView()
                                Text("Enviando...")
                            }
                        } else {
                            Text("Enviar")
                        }
                    }
                    .disabled(!vm.isValid || vm.isLoading)
                }
                
                // MARK: - Mensaje éxito
                if let success = vm.successMessage {
                    Section {
                        Text(success)
                            .foregroundColor(.green)
                    }
                }
                
                // MARK: - Error + Reintento
                if let error = vm.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                        
                        Button("Reintentar carga") {
                            Task { await vm.retryCarga() }
                        }
                    }
                }
                
                // MARK: - Listado
                Section(header: Text("Mis solicitudes")) {
                    ForEach(vm.solicitudes) { solicitud in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(solicitud.titulo)
                                .font(.headline)
                            
                            Text("Prioridad: \(solicitud.prioridad)")
                            
                            Text(solicitud.email)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Formulario")
            .task {
                await vm.retryCarga()
            }
        }
    }
}

#Preview {
    FormMainView()
}
