//
//  FetchPokemonEvolutionsUseCase.swift
//  Pokedex
//
//  Created by izadora montenegro on 29/08/26.
//


import Foundation

protocol FetchPokemonEvolutionsUseCase {
    func execute(id: Int) async throws -> [String]
}

final class DefaultFetchPokemonEvolutionsUseCase: FetchPokemonEvolutionsUseCase {

    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> [String] {
        try await repository.fetchEvolutions(pokemonID: id)
    }
}