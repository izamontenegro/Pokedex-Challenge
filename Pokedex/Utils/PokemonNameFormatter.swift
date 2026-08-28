//
//  PokemonNameFormatter.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//

import Foundation

enum PokemonNameFormatter {

    static func format(_ name: String) -> String {
        name
            .split(separator: "-")
            .map { $0.capitalized }
            .joined(separator: " ")
    }
}
