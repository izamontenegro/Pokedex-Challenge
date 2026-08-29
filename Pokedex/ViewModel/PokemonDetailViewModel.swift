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
    private(set) var evolutions: [String] = []
    private(set) var teamFeedback: Feedback?

    private let pokemonID: Int
    private let fetchDetailUseCase: FetchPokemonDetailUseCase
    private let fetchEvolutionsUseCase: FetchPokemonEvolutionsUseCase
    private let manageTeamUseCase: ManageTeamUseCase

    init(pokemonID: Int, fetchDetailUseCase: FetchPokemonDetailUseCase, manageTeamUseCase: ManageTeamUseCase, fetchEvolutionsUseCase: FetchPokemonEvolutionsUseCase) {
        self.pokemonID = pokemonID
        self.fetchDetailUseCase = fetchDetailUseCase
        self.manageTeamUseCase = manageTeamUseCase
        self.fetchEvolutionsUseCase = fetchEvolutionsUseCase
    }
    
    func load() async {
        state = .loading

        do {
            let pokemon = try await fetchDetailUseCase.execute(id: pokemonID)
            state = .loaded(pokemon)

            evolutions = (try? await fetchEvolutionsUseCase.execute(id: pokemonID)) ?? []
        } catch {
            state = .failure(message: error.localizedDescription)
        }
    }
    
    func addToTeam() {
        guard case .loaded(let pokemon) = state else { return }

        let member = TeamMember(
            id: pokemon.id,
            name: pokemon.name,
            spriteURL: pokemon.spriteURL,
            types: pokemon.types
        )

        do {
            try manageTeamUseCase.add(member)

            teamFeedback = Feedback(
                message: "\(PokemonDataFormatter.name(pokemon.name)) foi adicionado ao time.",
                type: .success
            )
        } catch let error as TeamError {
            switch error {
            case .alreadyInTeam(let name):
                teamFeedback = Feedback(
                    message: "\(PokemonDataFormatter.name(name)) já está no seu time.",
                    type: .warning
                )

            case .teamFull:
                teamFeedback = Feedback(
                    message: "Seu time já possui 6 Pokémon.",
                    type: .warning
                )
            }
        } catch {
            teamFeedback = Feedback(
                message: error.localizedDescription,
                type: .error
            )
        }
    }

    func clearTeamFeedback() {
        teamFeedback = nil
    }
}
