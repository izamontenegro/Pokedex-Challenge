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

    init(pokemonID: Int) {
        self.pokemonID = pokemonID

        let repository = RemotePokemonRepository(client: URLSessionHTTPClient())
        self.fetchDetail = DefaultFetchPokemonDetailUseCase(repository: repository)
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
