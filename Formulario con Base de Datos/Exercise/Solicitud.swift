import Foundation

struct Solicitud: Codable, Identifiable {
    let id: UUID
    let titulo: String
    let descripcion: String
    let categoria: String
    let prioridad: Int
    let email: String
    let created_at: Date?
}
