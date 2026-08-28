import SwiftUI

enum PokemonRoute: Hashable {
    case detail(id: Int)
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
                        }
                    }
            }
            
        }
    }
}
