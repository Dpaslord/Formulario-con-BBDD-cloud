//
//  Solicitud.swift
//  Formulario con Base de Datos
//
//  Created by David Pascual Lorenzo on 21/04/2026.
//

import Foundation

struct Solicitud: Codable, Identifiable {
    let id: UUID?
    let titulo: String
    let descripcion: String
    let categoria: String
    let prioridad: Int
    let email: String
    let created_at: Date?
}

