//
//  AppContainer.swift
//  Pokedex
//
//  Created by izadora montenegro on 29/08/26.
//
import Foundation

final class AppContainer {

    private let fetchPageUseCase: FetchPokemonPageUseCase
    private let fetchDetailUseCase: FetchPokemonDetailUseCase
    private let fetchEvolutionsUseCase: FetchPokemonEvolutionsUseCase
    private let manageTeamUseCase: ManageTeamUseCase

    init() {
        let client = URLSessionHTTPClient()
        let pokemonRepository = RemotePokemonRepository(client: client)
        let teamRepository = UserDefaultsTeamRepository()

        self.fetchPageUseCase = DefaultFetchPokemonPageUseCase(
            repository: pokemonRepository
        )

        self.fetchDetailUseCase = DefaultFetchPokemonDetailUseCase(
            repository: pokemonRepository
        )

        self.fetchEvolutionsUseCase = DefaultFetchPokemonEvolutionsUseCase(
            repository: pokemonRepository
        )

        self.manageTeamUseCase = DefaultManageTeamUseCase(
            repository: teamRepository
        )
    }

    @MainActor
    func makePokemonListViewModel() -> PokemonListViewModel {
        PokemonListViewModel(fetchPageUseCase: fetchPageUseCase)
    }

    @MainActor
    func makePokemonDetailViewModel(pokemonID: Int) -> PokemonDetailViewModel {
        PokemonDetailViewModel(
            pokemonID: pokemonID,
            fetchDetailUseCase: fetchDetailUseCase,
            manageTeamUseCase: manageTeamUseCase, fetchEvolutionsUseCase: fetchEvolutionsUseCase
        )
    }

    @MainActor
    func makePokemonTeamViewModel() -> PokemonTeamViewModel {
        PokemonTeamViewModel(manageTeamUseCase: manageTeamUseCase)
    }
}
