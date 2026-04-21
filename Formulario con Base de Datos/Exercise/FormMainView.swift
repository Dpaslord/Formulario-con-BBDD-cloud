import SwiftUI

struct FormMainView: View {
    
    @StateObject private var vm = FormViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Form {
                    
                    Section(header: Text("Formulario")) {
                        
                        TextField("Título", text: $vm.titulo)
                        TextField("Descripción", text: $vm.descripcion)
                        TextField("Categoría", text: $vm.categoria)
                        
                        Stepper("Prioridad: \(vm.prioridad)", value: $vm.prioridad, in: 1...5)
                        
                        TextField("Email", text: $vm.email)
                            .keyboardType(.emailAddress)
                        
                        Button(vm.isLoading ? "Enviando..." : "Enviar") {
                            Task { await vm.enviar() }
                        }
                        .disabled(!vm.isValid || vm.isLoading)
                    }
                    
                    if let error = vm.errorMessage {
                        Section {
                            Text(error)
                                .foregroundColor(.red)
                            
                            Button("Reintentar carga") {
                                Task { await vm.cargarSolicitudes() }
                            }
                        }
                    }
                    
                    Section(header: Text("Mis solicitudes")) {
                        ForEach(vm.solicitudes) { solicitud in
                            VStack(alignment: .leading) {
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
            }
            .navigationTitle("Formulario")
            .task {
                await vm.cargarSolicitudes()
            }
        }
    }
}

#Preview {
    FormMainView()
}
