//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class PokemonDetailViewModel {
    private(set) var pokemon: PokemonDetail?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let pokemonID: Int
    private let fetchDetail: FetchPokemonDetailUseCase

    init(
        pokemonID: Int,
        fetchDetail: FetchPokemonDetailUseCase
    ) {
        self.pokemonID = pokemonID
        self.fetchDetail = fetchDetail
    }

    convenience init(pokemonID: Int) {
        let repository = RemotePokemonRepository(
            client: URLSessionHTTPClient()
        )

        let fetchDetail = DefaultFetchPokemonDetailUseCase(
            repository: repository
        )

        self.init(
            pokemonID: pokemonID,
            fetchDetail: fetchDetail
        )
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            pokemon = try await fetchDetail.execute(id: pokemonID)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
