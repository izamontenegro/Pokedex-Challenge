import Foundation

struct PokemonPageItem: Equatable {
    let summary: PokemonSummary
    let detail: PokemonDetail
}

struct PokemonPageResult: Equatable {
    let items: [PokemonPageItem]
    let hasNextPage: Bool
}

protocol FetchPokemonPageUseCase {
    func execute(offset: Int) async throws -> PokemonPageResult
}

final class DefaultFetchPokemonPageUseCase: FetchPokemonPageUseCase {

    static let pageSize = 20

    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func execute(offset: Int) async throws -> PokemonPageResult {
        let page = try await repository.fetchPage(offset: offset, limit: Self.pageSize)

        let items = try await fetchDetails(for: page.items)

        return PokemonPageResult( items: items, hasNextPage: page.hasNextPage)
    }

    private func fetchDetails(for summaries: [PokemonSummary]) async throws -> [PokemonPageItem] {

        try await withThrowingTaskGroup(of: PokemonPageItem.self) { group in

            for summary in summaries {
                group.addTask {
                    let detail = try await self.repository.fetchDetail(
                        url: summary.detailURL
                    )

                    return PokemonPageItem(summary: summary,detail: detail)
                }
            }

            var items: [PokemonPageItem] = []

            for try await item in group {
                items.append(item)
            }

            return items.sorted {
                $0.detail.id < $1.detail.id
            }
        }
    }
}
