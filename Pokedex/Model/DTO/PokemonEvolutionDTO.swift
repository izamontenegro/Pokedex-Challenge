//
//  PokemonEvolutionDTO.swift
//  Pokedex
//
//  Created by izadora montenegro on 29/08/26.
//

import Foundation

struct PokemonSpeciesDTO: Decodable {
    let evolutionChain: EvolutionChain

    struct EvolutionChain: Decodable {
        let url: URL
    }
}

struct PokemonEvolutionChainDTO: Decodable {
    let chain: Chain

    struct Chain: Decodable {
        let species: Species
        let evolvesTo: [Chain]

        struct Species: Decodable {
            let name: String
        }
    }
}
