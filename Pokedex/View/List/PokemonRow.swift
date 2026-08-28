import SwiftUI

/// Linha da lista.
///
/// TODO (Tarefa 2): hoje a linha mostra só o nome raw vindo da API
/// ("bulbasaur"). Ela precisa mostrar:
///   - o nome formatado para leitura ("Bulbasaur", "Mr. Mime");
///   - o número na Pokédex, com três dígitos (#001);
///   - o sprite;
///   - as tags de tipo, coloridas com `Theme.Color.forPokemonType(_:)`.
struct PokemonRow: View {

    let row: PokemonRowModel

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            PokemonImage(url: row.spriteURL)
                .frame(width: 64, height: 64)
                .padding(Theme.Spacing.xs)
                .background(
                    Theme.Color.background,
                    in: Circle()
                )

            VStack(
                alignment: .leading,
                spacing: Theme.Spacing.xs
            ) {
                HStack {
                    Text(row.name.capitalized)
                        .font(Theme.Font.rowTitle)
                        .foregroundStyle(Theme.Color.primaryText)

                    Text(row.number)
                        .font(Theme.Font.caption)
                        .foregroundStyle(Theme.Color.secondaryText)
                }

                HStack(spacing: Theme.Spacing.xs) {
                    ForEach(row.types, id: \.self) { type in
                        Text(type.capitalized)
                            .font(Theme.Font.caption)
                            .foregroundStyle(.white)
                            .padding(.horizontal, Theme.Spacing.s)
                            .padding(.vertical, Theme.Spacing.xs)
                            .background(
                                Theme.Color.forPokemonType(type),
                                in: Capsule()
                            )
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, Theme.Spacing.xs)
    }
}

