//
//  PokemonTeamViewModel.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class PokemonTeamViewModel {

    enum State: Equatable {
        case empty
        case loaded(
            summary: TeamSummary,
            members: [TeamMember]
        )
    }

    private(set) var state: State = .empty

    private let manageTeamUseCase: ManageTeamUseCase

    init(manageTeamUseCase: ManageTeamUseCase) {
        self.manageTeamUseCase = manageTeamUseCase
    }

    func load() {
        let members = manageTeamUseCase.currentTeam()

        guard !members.isEmpty else {
            state = .empty
            return
        }

        state = .loaded(summary: manageTeamUseCase.summary(), members: members)
    }

    func remove(_ members: [TeamMember]) {
        for member in members {
            manageTeamUseCase.remove(id: member.id)
        }
        load()
    }
}
