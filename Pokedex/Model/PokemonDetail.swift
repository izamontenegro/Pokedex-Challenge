//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//
import Foundation

struct PokemonDetail: Equatable {
    let id: Int
    let name: String
    let spriteURL: URL?
    let types: [String]
}
