import SwiftUI

struct PokemonDetailView: View {

    let pokemon: PokemonDetailViewData

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.l) {
                pokemonHeaderView

                pokemonInfoView

                statsView
            }
            .padding(.bottom, Theme.Spacing.l)
        }
        .ignoresSafeArea(edges: .top)
    }

    private var pokemonHeaderView: some View {
        ZStack(alignment: .bottom) {
            Circle()
                .fill(Theme.Color.surface)
                .frame(
                    width: UIScreen.main.bounds.width * 1.25,
                    height: UIScreen.main.bounds.width * 1.25
                )
                .offset(y: -UIScreen.main.bounds.width * 0.45)

            PokemonImage(url: pokemon.spriteURL)
                .frame(width: 220, height: 220)
                .offset(y: 40)
        }
        .frame(height: 500)
    }

    private var pokemonInfoView: some View {
        VStack(spacing: Theme.Spacing.s) {
            Text("\(pokemon.name) \(pokemon.number)")
                .font(.title)
                .foregroundStyle(Theme.Color.primaryText)

            Text(
                "Altura: \(pokemon.height)   Peso: \(pokemon.weight)"
            )
            .font(Theme.Font.body)
            .foregroundStyle(Theme.Color.secondaryText)

            HStack(spacing: Theme.Spacing.s) {
                ForEach(pokemon.types, id: \.self) { type in
                    PokemonTypeTag(type: type)
                }
            }
        }
    }

    private var statsView: some View {
        HStack(spacing: Theme.Spacing.m) {
            PokemonStatCard(
                title: "HP",
                value: pokemon.hp
            )

            PokemonStatCard(
                title: "ATAQUE",
                value: pokemon.attack
            )

            PokemonStatCard(
                title: "DEFESA",
                value: pokemon.defense
            )
        }
        .padding(.horizontal, Theme.Spacing.l)
    }
}