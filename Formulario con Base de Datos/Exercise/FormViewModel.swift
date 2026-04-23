import Foundation
import Supabase
import Combine

/// ViewModel responsable de:
/// - Validación del formulario
/// - Gestión de estado de carga
/// - Comunicación con Supabase
/// - Manejo de errores y éxito
@MainActor
final class FormViewModel: ObservableObject {
    
    // MARK: - Campos del formulario
    
    /// Título de la solicitud
    @Published var titulo = ""
    
    /// Descripción detallada
    @Published var descripcion = ""
    
    /// Categoría opcional
    @Published var categoria = ""
    
    /// Nivel de prioridad (1–5)
    @Published var prioridad = 1
    
    /// Email del usuario
    @Published var email = ""
    
    // MARK: - Estados UI
    
    /// Indica si se está enviando o cargando información
    @Published var isLoading = false
    
    /// Mensaje de error mostrado en UI
    @Published var errorMessage: String?
    
    /// Mensaje de éxito mostrado en UI
    @Published var successMessage: String?
    
    /// Lista de solicitudes obtenidas del backend
    @Published var solicitudes: [Solicitud] = []
    
    // MARK: - Validaciones individuales
    
    /// Valida el título (5–60 caracteres)
    var isTituloValido: Bool {
        let t = titulo.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.count >= 5 && t.count <= 60
    }
    
    /// Valida la descripción (20–500 caracteres)
    var isDescripcionValida: Bool {
        let d = descripcion.trimmingCharacters(in: .whitespacesAndNewlines)
        return d.count >= 20 && d.count <= 500
    }
    
    /// Valida el formato del email usando regex
    var isEmailValido: Bool {
        let regex = #"^\S+@\S+\.\S+$"#
        return email.range(of: regex, options: .regularExpression) != nil
    }
    
    /// Indica si el formulario completo es válido
    var isValid: Bool {
        isTituloValido &&
        isDescripcionValida &&
        isEmailValido &&
        prioridad >= 1 && prioridad <= 5
    }
    
    // MARK: - Envío
    
    /// Inserta una nueva solicitud en Supabase.
    /// Gestiona estados de carga, errores y confirmación de éxito.
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
                id: UUID(), // Generado en cliente para evitar duplicados
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
    
    // MARK: - Carga de datos
    
    /// Obtiene las solicitudes ordenadas por fecha descendente
    func cargarSolicitudes() async throws {
        solicitudes = try await SupabaseManager.shared.fetchSolicitudes()
    }
    
    /// Reintento manual de carga tras error
    func retryCarga() async {
        do {
            try await cargarSolicitudes()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Utilidades
    
    /// Limpia los campos del formulario tras envío exitoso
    private func resetForm() {
        titulo = ""
        descripcion = ""
        categoria = ""
        prioridad = 1
        email = ""
    }
}
