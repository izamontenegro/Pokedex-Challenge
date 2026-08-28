import Foundation

struct TeamMember: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let spriteURL: URL?
    let types: [String]
}

struct TeamSummary: Equatable {
    let count: Int
    let coveredTypes: [String]
}
