import Foundation

/// Modelo que representa una solicitud almacenada en Supabase.
struct Solicitud: Codable, Identifiable {
    
    /// Identificador único (UUID generado en cliente)
    let id: UUID
    
    /// Título de la solicitud
    let titulo: String
    
    /// Descripción detallada
    let descripcion: String
    
    /// Categoría asociada
    let categoria: String
    
    /// Nivel de prioridad (1–5)
    let prioridad: Int
    
    /// Email del usuario
    let email: String
    
    /// Fecha de creación (generada por la base de datos)
    let created_at: Date?
}
