import Foundation

/// Uma página da listagem de Pokémon.
struct PokemonPage: Equatable {
    let items: [PokemonSummary]
    let totalCount: Int
    let hasNextPage: Bool
}

protocol PokemonRepository {
    func fetchPage(offset: Int, limit: Int) async throws -> PokemonPage
    func fetchDetail(url: URL) async throws -> PokemonDetail
    func fetchEvolutions(pokemonID: Int) async throws -> [String]
}

final class RemotePokemonRepository: PokemonRepository {

    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func fetchPage(offset: Int, limit: Int) async throws -> PokemonPage {
        let url = PokeAPI.pokemonList(limit: limit, offset: offset)
        let dto = try await client.get(url, as: PokemonListResponseDTO.self)

        let items = dto.results.compactMap { item -> PokemonSummary? in
            guard let url = URL(string: item.url) else { return nil }
            return PokemonSummary(name: item.name, detailURL: url)
        }

        return PokemonPage(
            items: items,
            totalCount: dto.count,
            hasNextPage: dto.next != nil
        )
    }
    
    func fetchDetail(url: URL) async throws -> PokemonDetail {
        let dto = try await client.get(url, as: PokemonDetailDTO.self)

        let stats = dto.stats.compactMap { statDTO -> PokemonStatValue? in
            guard let stat = PokemonStat(
                rawValue: statDTO.stat.name
            ) else {
                return nil
            }

            return PokemonStatValue(stat: stat, value: statDTO.baseStat)
        }

        return PokemonDetail(
            id: dto.id,
            name: dto.name,
            height: dto.height,
            weight: dto.weight,
            spriteURL: dto.sprites.frontDefault,
            types: dto.types.map { $0.type.name },
            stats: stats
        )
    }
    
    func fetchEvolutions(pokemonID: Int) async throws -> [String] {
        let species = try await client.get(
            PokeAPI.pokemonSpecies(id: pokemonID),
            as: PokemonSpeciesDTO.self
        )

        let evolutionChain = try await client.get(
            species.evolutionChain.url,
            as: PokemonEvolutionChainDTO.self
        )

        return evolutionNames(from: evolutionChain.chain)
    }

    private func evolutionNames(from chain: PokemonEvolutionChainDTO.Chain) -> [String] {
        [chain.species.name] + chain.evolvesTo.flatMap { evolutionNames(from: $0) }
    }
}
