import SwiftUI

enum PokemonRoute: Hashable {
    case detail(id: Int)
    case team
}

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PokemonListView(viewModel: PokemonListViewModel())
                    .navigationDestination(
                        for: PokemonRoute.self
                    ) { route in
                        switch route {
                        case .detail(let id):
                            PokemonDetailView(
                                viewModel: PokemonDetailViewModel(
                                    pokemonID: id
                                )
                            )
                            
                        case .team:
                            PokemonTeamView(
                                viewModel: PokemonTeamViewModel()
                            )
                        }
                    }
            }
        }
    }
}
