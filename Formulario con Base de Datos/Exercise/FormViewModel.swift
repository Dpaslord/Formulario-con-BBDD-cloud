import Foundation
import Supabase
import Combine

@MainActor
final class FormViewModel: ObservableObject {
    
    // MARK: - Campos
    
    @Published var titulo = ""
    @Published var descripcion = ""
    @Published var categoria = ""
    @Published var prioridad = 1
    @Published var email = ""
    
    // MARK: - Estados
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var solicitudes: [Solicitud] = []
    
    // MARK: - Validaciones individuales
    
    var isTituloValido: Bool {
        let t = titulo.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.count >= 5 && t.count <= 60
    }
    
    var isDescripcionValida: Bool {
        let d = descripcion.trimmingCharacters(in: .whitespacesAndNewlines)
        return d.count >= 20 && d.count <= 500
    }
    
    var isEmailValido: Bool {
        let regex = #"^\S+@\S+\.\S+$"#
        return email.range(of: regex, options: .regularExpression) != nil
    }
    
    var isValid: Bool {
        isTituloValido &&
        isDescripcionValida &&
        isEmailValido &&
        prioridad >= 1 && prioridad <= 5
    }
    
    // MARK: - Enviar
    
    func enviar() async {
        guard isValid else {
            errorMessage = "Revisa los campos antes de enviar."
            return
        }
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        defer { isLoading = false }
        
        do {
            let nuevaSolicitud = Solicitud(
                id: UUID(),
                titulo: titulo.trimmingCharacters(in: .whitespacesAndNewlines),
                descripcion: descripcion.trimmingCharacters(in: .whitespacesAndNewlines),
                categoria: categoria.trimmingCharacters(in: .whitespacesAndNewlines),
                prioridad: prioridad,
                email: email.lowercased(),
                created_at: nil
            )
            
            try await SupabaseManager.shared.insertSolicitud(nuevaSolicitud)
            
            successMessage = "Solicitud enviada correctamente ✅"
            
            resetForm()
            try await cargarSolicitudes()
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Carga
    
    func cargarSolicitudes() async throws {
        solicitudes = try await SupabaseManager.shared.fetchSolicitudes()
    }
    
    func retryCarga() async {
        do {
            try await cargarSolicitudes()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Reset
    
    private func resetForm() {
        titulo = ""
        descripcion = ""
        categoria = ""
        prioridad = 1
        email = ""
    }
}
