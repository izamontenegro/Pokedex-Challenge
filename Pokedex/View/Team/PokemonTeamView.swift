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
            StateView(
                content: .empty(
                    message: "Seu time ainda está vazio."
                )
            )

        case .loaded(let members, let summary):
            List {
                teamSummary(summary)

                Section("Pokémon") {
                    ForEach(members) { member in
                        TeamMemberRow(member: member)
                    }
                    .onDelete { indexSet in
                        removeMembers(
                            at: indexSet,
                            from: members
                        )
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }

    private func teamSummary(
        _ summary: TeamSummary
    ) -> some View {
        Section("Resumo") {
            VStack(
                alignment: .leading,
                spacing: Theme.Spacing.m
            ) {
                Text(
                    "\(summary.count) de \(Team.maxSize) Pokémon"
                )
                .font(Theme.Font.rowTitle)

                VStack(
                    alignment: .leading,
                    spacing: Theme.Spacing.s
                ) {
                    Text("Tipos cobertos")
                        .font(Theme.Font.caption)
                        .foregroundStyle(
                            Theme.Color.secondaryText
                        )

                    FlowLayout {
                        ForEach(
                            summary.coveredTypes,
                            id: \.self
                        ) { type in
                            PokemonTypeTag(type: type)
                        }
                    }
                }
            }
            .padding(.vertical, Theme.Spacing.s)
        }
    }

    private func removeMembers(
        at indexSet: IndexSet,
        from members: [TeamMember]
    ) {
        for index in indexSet {
            viewModel.remove(
                id: members[index].id
            )
        }
    }
}