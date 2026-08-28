//
//  PokemonTypeTag.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//

import SwiftUI

struct PokemonTypeTag: View {

    let type: String

    var body: some View {
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

#Preview {
    PokemonTypeTag(type: "fire")
}
