import Foundation

enum TeamError: LocalizedError, Equatable {
    case alreadyInTeam(name: String)
    case teamFull

    var errorDescription: String? {
        switch self {
        case .alreadyInTeam(let name):
            return "\(name) já está no seu time."

        case .teamFull:
            return "Seu time já possui 6 Pokémon."
        }
    }
}

enum Team {
    static let maxSize = 6
}

protocol ManageTeamUseCase {
    func currentTeam() -> [TeamMember]
    func add(_ member: TeamMember) throws
    func remove(id: Int)
    func summary() -> TeamSummary
}

final class DefaultManageTeamUseCase: ManageTeamUseCase {

    private let repository: TeamRepository

    init(repository: TeamRepository) {
        self.repository = repository
    }

    func currentTeam() -> [TeamMember] {
        repository.load()
    }

    // MARK: - TODO (Tarefa 4)
    //
    // O contrato esperado:
    //
    // - `add`: adiciona novo Pokémon no time
    // - `remove`: remove Pokémon do time pelo id
    // - `summary`: ver a documentação de `TeamSummary` em `Model/Team.swift`.
    
    func add(_ member: TeamMember) throws {
        var members = repository.load()

        guard !members.contains(where: { $0.id == member.id }) else {
            throw TeamError.alreadyInTeam(name: member.name)
        }

        guard members.count < Team.maxSize else {
            throw TeamError.teamFull
        }

        members.append(member)

        repository.save(members)
    }

    func remove(id: Int) {
        var members = repository.load()

        members.removeAll { $0.id == id }

        repository.save(members)
    }

    func summary() -> TeamSummary {
        let members = repository.load()

        let coveredTypes = Array(
            Set(
                members.flatMap(\.types)
            )
        )
        .sorted()

        return TeamSummary(
            count: members.count,
            coveredTypes: coveredTypes
        )
    }
}
