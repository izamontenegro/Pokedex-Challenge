//
//  TeamMemberRow.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//

import SwiftUI

struct TeamMemberRow: View {

    let member: TeamMember

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            PokemonImage(url: member.spriteURL)
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
                Text(
                    PokemonDataFormatter.name(
                        member.name
                    )
                )
                .font(Theme.Font.rowTitle)

                HStack(spacing: Theme.Spacing.xs) {
                    ForEach(
                        member.types,
                        id: \.self
                    ) { type in
                        PokemonTypeTag(type: type)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, Theme.Spacing.xs)
    }
}
