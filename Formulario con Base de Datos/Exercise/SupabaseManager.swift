import Foundation
import Supabase

class SupabaseManager {
    
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        // Obtenemos las variables de entorno configuradas en el Scheme
        guard
            let urlString = ProcessInfo.processInfo.environment["SUPABASE_URL"],
            let key = ProcessInfo.processInfo.environment["SUPABASE_KEY"],
            let url = URL(string: urlString)
        else {
            fatalError("Variables de entorno no configuradas")
        }
        
        // Configuramos las opciones de Auth de forma que Xcode las reconozca automáticamente
        let options = SupabaseClientOptions(
            auth: .init(
                emitLocalSessionAsInitialSession: true
            )
        )
        
        // Inicializamos el cliente
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: key,
            options: options
        )
    }
}
