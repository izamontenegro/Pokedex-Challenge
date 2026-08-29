import SwiftUI

struct PokemonListView: View {

    @State private var viewModel: PokemonListViewModel

    init(viewModel: PokemonListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .overlay(alignment: .bottom) {
                if let feedback = viewModel.paginationFeedback {
                    FeedbackToast(feedback: feedback)
                        .padding(.bottom, Theme.Spacing.m)
                }
            }
            .animation(.easeInOut, value: viewModel.paginationFeedback)
            .navigationTitle("Pokédex")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Meu Time", value: PokemonRoute.team)
                }
            }
            .task {
                await viewModel.load()
            }
            .task(id: viewModel.paginationFeedback) {
                guard viewModel.paginationFeedback != nil else { return }

                try? await Task.sleep(for: .seconds(3))
                viewModel.clearPaginationFeedback()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            StateView(content: .loading)

        case .loaded(let rows):
            list(rows)

        case .empty:
            StateView(content: .empty(message: "Nenhum Pokémon encontrado."))

        case .failure(let message):
            StateView(content: .failure(message: message)) {
                Task {
                    await viewModel.load()
                }
            }
        }
    }

    private func list(_ rows: [PokemonRowModel]) -> some View {
        List {
            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                NavigationLink(value: PokemonRoute.detail(id: row.id)) {
                    PokemonRow(row: row)
                }
                .task {
                    await viewModel.loadNextPageIfNeeded(displayingRowAt: index)
                }
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            await viewModel.reload()
        }
    }
}

#Preview {
    NavigationStack {
        PokemonListView(viewModel: PokemonListViewModel())
    }
}
