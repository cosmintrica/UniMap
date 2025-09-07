//
//  Catalog.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//


import Foundation

struct Catalog {
    static let cities = ["Craiova"]

    static let universitiesByCity: [String: [String]] = [
        "Craiova": ["Universitatea din Craiova"]
    ]

    static let facultiesByUniversity: [String: [String]] = [
        "Universitatea din Craiova": [
            "Facultatea de Litere",
            "Facultatea de Științe",
            "Facultatea de Științe Economice și Administrarea Afacerilor",
            "Facultatea de Automatică, Calculatoare și Electronică"
        ]
    ]

    static let specializationsByFaculty: [String: [String]] = [
        "Facultatea de Litere": ["Română-Engleză", "Comunicare și relații publice"],
        "Facultatea de Științe": ["Informatică", "Matematică"],
        "Facultatea de Științe Economice și Administrarea Afacerilor": ["Contabilitate", "Marketing", "Management"],
        "Facultatea de Automatică, Calculatoare și Electronică": ["Calculatoare", "Automatică", "Electronică"]
    ]
}
