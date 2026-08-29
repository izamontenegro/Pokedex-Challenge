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

    private let manageTeam: ManageTeamUseCase

    init() {
        let repository = UserDefaultsTeamRepository()

        self.manageTeam = DefaultManageTeamUseCase(repository: repository)
    }

    func load() {
        let members = manageTeam.currentTeam()

        guard !members.isEmpty else {
            state = .empty
            return
        }

        state = .loaded(summary: manageTeam.summary(), members: members)
    }

    func remove(_ members: [TeamMember]) {
        for member in members {
            manageTeam.remove(id: member.id)
        }
        load()
    }
}
