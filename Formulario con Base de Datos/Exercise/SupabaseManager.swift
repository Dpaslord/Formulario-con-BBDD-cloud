import Foundation
import Supabase

class SupabaseManager {
    
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        
        guard
            let urlString = ProcessInfo.processInfo.environment["SUPABASE_URL"],
            let key = ProcessInfo.processInfo.environment["SUPABASE_KEY"],
            let url = URL(string: urlString)
        else {
            fatalError("Variables de entorno no configuradas")
        }
        
        client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: key
        )
    }
}
