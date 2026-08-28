//
//  PokemonDataFormatter.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//

import Foundation

enum PokemonDataFormatter {
    static func name(_ name: String) -> String {
        name
            .split(separator: "-")
            .map { $0.capitalized }
            .joined(separator: " ")
    }

    static func number(_ id: Int) -> String {
        String(format: "#%03d", id)
    }

    static func height(_ height: Int) -> String {
        "\(Double(height) / 10)m"
    }

    static func weight(_ weight: Int) -> String {
        "\(Double(weight) / 10)kg"
    }
}
