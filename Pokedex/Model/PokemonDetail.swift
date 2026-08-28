//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//

import Foundation

enum PokemonStat: String, Equatable, CaseIterable {
    case hp
    case attack
    case defense
    
    var title: String {
        switch self {
        case .hp:
            "HP"
        case .attack:
            "ATAQUE"
        case .defense:
            "DEFESA"
        }
    }
}

struct PokemonStatValue: Equatable {
    let stat: PokemonStat
    let value: Int
}

struct PokemonDetail: Equatable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let spriteURL: URL?
    let types: [String]
    let stats: [PokemonStatValue]

    func statValue(for stat: PokemonStat) -> Int {
        stats.first {
            $0.stat == stat
        }?.value ?? 0
    }
}
