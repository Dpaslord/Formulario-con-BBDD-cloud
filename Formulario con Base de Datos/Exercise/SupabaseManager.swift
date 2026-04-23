import Foundation
import Supabase

enum SupabaseError: LocalizedError {
    case decodingError
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Error al procesar los datos del servidor."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

final class SupabaseManager {
    
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        guard
            let urlString = ProcessInfo.processInfo.environment["SUPABASE_URL"],
            let key = ProcessInfo.processInfo.environment["SUPABASE_KEY"],
            let url = URL(string: urlString)
        else {
            fatalError("Variables de entorno de Supabase no configuradas.")
        }
        
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: key
        )
    }
    
    func insertSolicitud(_ solicitud: Solicitud) async throws {
        do {
            try await client
                .from("solicitudes")
                .insert(solicitud)
                .execute()
        } catch {
            throw SupabaseError.unknown(error)
        }
    }
    
    func fetchSolicitudes() async throws -> [Solicitud] {
        do {
            let response: [Solicitud] = try await client
                .from("solicitudes")
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value
            
            return response
        } catch let decodingError as DecodingError {
            throw SupabaseError.decodingError
        } catch {
            throw SupabaseError.unknown(error)
        }
    }
}
