import SwiftUI

enum PokemonRoute: Hashable {
    case detail(id: Int)
    case team
}

@main
struct PokedexApp: App {

    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PokemonListView(
                    viewModel: container.makePokemonListViewModel()
                )
                .navigationDestination(for: PokemonRoute.self) { route in
                    switch route {
                    case .detail(let id):
                        PokemonDetailView(
                            viewModel: container.makePokemonDetailViewModel(
                                pokemonID: id
                            )
                        )

                    case .team:
                        PokemonTeamView(
                            viewModel: container.makePokemonTeamViewModel()
                        )
                    }
                }
            }
        }
    }
}
