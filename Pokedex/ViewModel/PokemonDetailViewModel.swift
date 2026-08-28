import Foundation

@MainActor
@Observable
final class PokemonDetailViewModel {

    struct ViewData: Equatable {
        let name: String
        let number: String
        let height: String
        let weight: String
        let spriteURL: URL?
        let types: [String]
        let hp: Int
        let attack: Int
        let defense: Int
    }

    enum State: Equatable {
        case loading
        case loaded(ViewData)
        case failure(message: String)
    }

    private(set) var state: State = .loading

    private let pokemonID: Int
    private let fetchDetail: FetchPokemonDetailUseCase

    init(
        pokemonID: Int,
        fetchDetail: FetchPokemonDetailUseCase
    ) {
        self.pokemonID = pokemonID
        self.fetchDetail = fetchDetail
    }

    convenience init(pokemonID: Int) {
        let repository = RemotePokemonRepository(
            client: URLSessionHTTPClient()
        )

        let fetchDetail = DefaultFetchPokemonDetailUseCase(
            repository: repository
        )

        self.init(
            pokemonID: pokemonID,
            fetchDetail: fetchDetail
        )
    }

    func load() async {
        state = .loading

        do {
            let detail = try await fetchDetail.execute(
                id: pokemonID
            )

            state = .loaded(
                makeViewData(from: detail)
            )

        } catch {
            state = .failure(
                message: error.localizedDescription
            )
        }
    }

    private func makeViewData(
        from detail: PokemonDetail
    ) -> ViewData {
        ViewData(
            name: PokemonFormatter.name(detail.name),
            number: PokemonFormatter.number(detail.id),
            height: formatHeight(detail.height),
            weight: formatWeight(detail.weight),
            spriteURL: detail.spriteURL,
            types: detail.types,
            hp: statValue(.hp, in: detail),
            attack: statValue(.attack, in: detail),
            defense: statValue(.defense, in: detail)
        )
    }

    private func statValue(
        _ stat: PokemonStat,
        in detail: PokemonDetail
    ) -> Int {
        detail.stats.first {
            $0.stat == stat
        }?.value ?? 0
    }

    private func formatHeight(_ height: Int) -> String {
        "\(Double(height) / 10)m"
    }

    private func formatWeight(_ weight: Int) -> String {
        "\(Double(weight) / 10)kg"
    }
}