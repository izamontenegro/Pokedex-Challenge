//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//
import SwiftUI

struct PokemonDetailView: View {

    @State private var viewModel: PokemonDetailViewModel

    init(viewModel: PokemonDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .overlay(alignment: .bottom) {
                if let feedback = viewModel.teamFeedback {
                    FeedbackToast(feedback: feedback)
                        .padding(.bottom, Theme.Spacing.m)
                }
            }
            .animation(
                .easeInOut,
                value: viewModel.teamFeedback
            )
            .task {
                await viewModel.load()
            }
            .task(id: viewModel.teamFeedback) {
                guard viewModel.teamFeedback != nil else { return }
                
                try? await Task.sleep(for: .seconds(3))
                viewModel.clearTeamFeedback()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            StateView(content: .loading)

        case .loaded(let pokemon):
            PokemonDetailContentView(
                pokemon: pokemon,
                onAddToTeam: {
                    viewModel.addToTeam()
                }
            )

        case .failure(let message):
            StateView(
                content: .failure(
                    message: message
                )
            ) {
                Task {
                    await viewModel.load()
                }
            }
        }
    }
}

private struct PokemonDetailContentView: View {
    let pokemon: PokemonDetail
    let onAddToTeam: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Theme.Color.background
                .ignoresSafeArea()
            
            CurvedBackgroundShape()
                .fill(Theme.Color.forPokemonType(pokemon.types.first).opacity(0.5))
                .frame(height: 360)
                .ignoresSafeArea(edges: .top)

            ScrollView {
                VStack(spacing: Theme.Spacing.l) {
                    pokemonInfoView
                    statsView
                    Spacer()
                    addToTeamButton
                }
                .padding(.bottom, Theme.Spacing.l)
            }
        }
    }

    private var pokemonInfoView: some View {
        VStack(spacing: Theme.Spacing.s) {
            PokemonImage(url: pokemon.spriteURL)
            .frame(width: 250, height: 250)
            
            Text(
                "\(PokemonDataFormatter.name(pokemon.name)) \(PokemonDataFormatter.number(pokemon.id))"
            )
            .font(Theme.Font.title)
            .foregroundStyle(Theme.Color.primaryText)

            HStack(spacing: Theme.Spacing.l) {
                Text("Altura: \(PokemonDataFormatter.height(pokemon.height))")

                Text("Peso: \(PokemonDataFormatter.weight(pokemon.weight))")
            }
            .font(Theme.Font.body)
            .foregroundStyle(
                Theme.Color.secondaryText
            )

            HStack(spacing: Theme.Spacing.s) {
                ForEach(pokemon.types, id: \.self) { type in
                    PokemonTypeTag(type: type)
                }
            }
        }
    }

    private var statsView: some View {
        HStack {
            ForEach(PokemonStat.allCases, id: \.self) { stat in
                PokemonStatCard(title: stat.title, value: pokemon.statValue(for: stat))
            }
        }
        .padding(.horizontal, Theme.Spacing.m)
    }

    private var addToTeamButton: some View {
        Button {
            onAddToTeam()
        } label: {
            Text("Adicionar ao time")
                .font(Theme.Font.body)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Theme.Color.accent)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Theme.Spacing.m)
    }
}
