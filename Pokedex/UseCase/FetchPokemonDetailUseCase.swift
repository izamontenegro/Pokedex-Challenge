//
//  FetchPokemonDetailUseCase.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//

import Foundation

protocol FetchPokemonDetailUseCase {
    func execute(id: Int) async throws -> PokemonDetail
}

final class DefaultFetchPokemonDetailUseCase: FetchPokemonDetailUseCase {

    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> PokemonDetail {
        try await repository.fetchDetail(
            url: PokeAPI.pokemon(id: id)
        )
    }
}
