import Foundation
import Supabase
import Combine

@MainActor
class FormViewModel: ObservableObject {
    
    @Published var titulo = ""
    @Published var descripcion = ""
    @Published var categoria = ""
    @Published var prioridad = 1
    @Published var email = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var solicitudes: [Solicitud] = []
    
    var isValid: Bool {
        titulo.count >= 5 && titulo.count <= 60 &&
        descripcion.count >= 20 && descripcion.count <= 500 &&
        isValidEmail(email) &&
        prioridad >= 1 && prioridad <= 5
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^\S+@\S+\.\S+$"#
        return email.range(of: regex, options: .regularExpression) != nil
    }
    
    func enviar() async {
        guard isValid else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let nuevaSolicitud = Solicitud(
                id: nil,
                titulo: titulo,
                descripcion: descripcion,
                categoria: categoria,
                prioridad: prioridad,
                email: email,
                created_at: nil
            )
            
            try await SupabaseManager.shared.client
                .from("solicitudes")
                .insert(nuevaSolicitud)
                .execute()
            
            await cargarSolicitudes()
            resetForm()
            
        } catch {
            errorMessage = "Error al enviar. Revisa la conexión o permisos RLS."
            print("Error: \(error)")
        }
        isLoading = false
    }
    
    func cargarSolicitudes() async {
        do {
            let response: [Solicitud] = try await SupabaseManager.shared.client
                .from("solicitudes")
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value
            
            solicitudes = response
            
        } catch {
            errorMessage = "Error al cargar solicitudes."
            print("Error: \(error)")
        }
    }
    
    private func resetForm() {
        titulo = ""
        descripcion = ""
        categoria = ""
        prioridad = 1
        email = ""
    }
}   
