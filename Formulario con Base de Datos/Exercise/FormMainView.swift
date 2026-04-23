import SwiftUI

/// Vista principal que contiene:
/// - Formulario con validación visual
/// - Mensajes de error y éxito
/// - Listado de solicitudes almacenadas
struct FormMainView: View {
    
    /// ViewModel que gestiona la lógica de negocio y estado
    @StateObject private var vm = FormViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                
                // MARK: - Formulario
                
                Section(header: Text("Formulario")) {
                    
                    // MARK: Título
                    
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
                    
                    // MARK: Descripción
                    
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
                    
                    // MARK: Categoría
                    
                    TextField("Categoría", text: $vm.categoria)
                    
                    // MARK: Prioridad
                    
                    Stepper("Prioridad: \(vm.prioridad)",
                            value: $vm.prioridad,
                            in: 1...5)
                    
                    // MARK: Email
                    
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
                    
                    // MARK: Botón Enviar
                    
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
                
                // MARK: Mensaje éxito
                
                if let success = vm.successMessage {
                    Section {
                        Text(success)
                            .foregroundColor(.green)
                    }
                }
                
                // MARK: Error + Reintento
                
                if let error = vm.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                        
                        Button("Reintentar carga") {
                            Task { await vm.retryCarga() }
                        }
                    }
                }
                
                // MARK: Listado de solicitudes
                
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
