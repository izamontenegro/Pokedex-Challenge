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

    enum State: Equatable {
        case loading
        case loaded(PokemonDetail)
        case failure(message: String)
    }

    private(set) var state: State = .loading

    private let pokemonID: Int
    private let fetchDetail: FetchPokemonDetailUseCase
    private let manageTeam: ManageTeamUseCase
    
    private(set) var teamFeedbackMessage: String?

    init(pokemonID: Int) {
        self.pokemonID = pokemonID

        let pokemonRepository = RemotePokemonRepository(
            client: URLSessionHTTPClient()
        )

        let teamRepository = UserDefaultsTeamRepository()

        self.fetchDetail = DefaultFetchPokemonDetailUseCase(
            repository: pokemonRepository
        )

        self.manageTeam = DefaultManageTeamUseCase(
            repository: teamRepository
        )
    }
    
    func load() async {
        state = .loading

        do {
            let pokemon = try await fetchDetail.execute(
                id: pokemonID
            )

            state = .loaded(pokemon)

        } catch {
            state = .failure(
                message: error.localizedDescription
            )
        }
    }
    
    func addToTeam() {
        guard case .loaded(let pokemon) = state else {
            return
        }

        let member = TeamMember(
            id: pokemon.id,
            name: pokemon.name,
            spriteURL: pokemon.spriteURL,
            types: pokemon.types
        )

        do {
            try manageTeam.add(member)
            teamFeedbackMessage = "\(PokemonDataFormatter.name(pokemon.name)) foi adicionado ao time."
        } catch {
            teamFeedbackMessage = error.localizedDescription
        }
    }

    func clearTeamFeedback() {
        teamFeedbackMessage = nil
    }
}
