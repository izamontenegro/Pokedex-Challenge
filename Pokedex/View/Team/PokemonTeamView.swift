//
//  PokemonTeamView.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//

import SwiftUI

struct PokemonTeamView: View {

    @State private var viewModel: PokemonTeamViewModel

    init(viewModel: PokemonTeamViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .navigationTitle("Meu Time")
            .task {
                viewModel.load()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .empty:
            StateView(content: .empty(message: "Seu time está vazio."))

        case .loaded(let summary, let members):
            List {
                teamSummary(summary)
                
                ForEach(members) { member in
                    TeamMemberRow(member: member)
                }
                .onDelete { indexSet in
                    let membersToRemove = indexSet.map { members[$0] }
                    viewModel.remove(membersToRemove)
                }
                
            }
            .listStyle(.sidebar)
        }
    }

    private func teamSummary(_ summary: TeamSummary) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            Text("\(summary.count)/\(Team.maxSize) Pokémons")
                .font(Theme.Font.rowTitle)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                Text("Tipos do time")
                    .font(Theme.Font.caption)
                    .foregroundStyle(Theme.Color.secondaryText)
                
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack(spacing: Theme.Spacing.xs) {
                        ForEach(summary.coveredTypes, id: \.self) { type in
                            PokemonTypeTag(type: type)
                        }
                    }
                }
            }
        }
        .padding(.vertical, Theme.Spacing.s)
    }
}

#Preview {
    NavigationStack {
        PokemonTeamView(
            viewModel: PokemonTeamViewModel()
        )
    }
}
