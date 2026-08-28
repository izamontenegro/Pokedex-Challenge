//
//  PokemonDetailDTO.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//

import Foundation

struct PokemonDetailDTO: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: SpritesDTO
    let types: [PokemonTypeSlotDTO]
    let stats: [PokemonStatDTO]
}

struct SpritesDTO: Decodable {
    let frontDefault: URL?
}

struct PokemonTypeSlotDTO: Decodable {
    let type: PokemonTypeDTO
}

struct PokemonTypeDTO: Decodable {
    let name: String
}

struct PokemonStatDTO: Decodable {
    let baseStat: Int
    let stat: StatDTO
}

struct StatDTO: Decodable {
    let name: String
}

