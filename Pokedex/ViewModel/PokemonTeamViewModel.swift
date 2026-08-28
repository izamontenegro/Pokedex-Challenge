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
            members: [TeamMember],
            summary: TeamSummary
        )
    }

    private(set) var state: State = .empty

    private let manageTeam: ManageTeamUseCase

    init() {
        let repository = UserDefaultsTeamRepository()

        self.manageTeam = DefaultManageTeamUseCase(
            repository: repository
        )
    }

    func load() {
        let members = manageTeam.currentTeam()

        guard !members.isEmpty else {
            state = .empty
            return
        }

        state = .loaded(
            members: members,
            summary: manageTeam.summary()
        )
    }

    func remove(id: Int) {
        manageTeam.remove(id: id)
        load()
    }
}