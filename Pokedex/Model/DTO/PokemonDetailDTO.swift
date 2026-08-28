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
    let sprites: SpritesDTO
    let types: [PokemonTypeSlotDTO]
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
