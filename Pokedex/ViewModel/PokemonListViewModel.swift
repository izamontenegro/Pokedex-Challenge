import Foundation

/// O que uma linha da lista precisa para se desenhar.
struct PokemonRowModel: Identifiable, Equatable {
    let id: Int
    let name: String
    let number: String
    let spriteURL: URL?
    let types: [String]
    let detailURL: URL
}

@MainActor
@Observable
final class PokemonListViewModel {
    
    enum State: Equatable {
        case loading
        case loaded([PokemonRowModel])
        case empty
        case failure(message: String)
    }
    
    /// A View observa isto. O ViewModel nunca importa SwiftUI.
    private(set) var state: State = .loading
    
    private let fetchPage: FetchPokemonPageUseCase
    
    private var hasNextPage = true
    private var isLoadingNextPage = false
    
    private(set) var paginationFeedback: Feedback?
    
    init() {
        let repository = RemotePokemonRepository(client: URLSessionHTTPClient())
        
        self.fetchPage = DefaultFetchPokemonPageUseCase( repository: repository)
    }
    
    func load() async {
        state = .loading
        await loadFirstPage()
    }
    
    func reload() async {
        await loadFirstPage()
    }
    
    private func makeRows(from items: [PokemonPageItem]) -> [PokemonRowModel] {
        items.map { item in
            PokemonRowModel(
                id: item.detail.id,
                name: PokemonDataFormatter.name(
                    item.summary.name
                ),
                number: PokemonDataFormatter.number(item.detail.id),
                spriteURL: item.detail.spriteURL,
                types: item.detail.types,
                detailURL: item.summary.detailURL
            )
        }
    }
    
    private func loadFirstPage() async {
        do {
            let page = try await fetchPage.execute(offset: 0)
            let rows = makeRows(from: page.items)
            hasNextPage = page.hasNextPage
            state = rows.isEmpty ? .empty : .loaded(rows)
        } catch {
            state = .failure(message: error.localizedDescription)
        }
    }
    
    // MARK: - TODO (Tarefa 1)
    //
    // A lista carrega só a primeira página (20 Pokémon).
    // Este método é chamado pela View a cada linha que aparece na tela.
    func loadNextPageIfNeeded(displayingRowAt index: Int) async {
        guard case .loaded(let rows) = state else { return }
        
        let threshold = rows.count - 5
        
        guard
            index >= threshold,
            hasNextPage,
            !isLoadingNextPage
        else { return }
        
        isLoadingNextPage = true
        
        defer { isLoadingNextPage = false }
        
        do {
            let page = try await fetchPage.execute(offset: rows.count)
            
            let newRows = makeRows(from: page.items)
            
            let updatedRows = rows + newRows
            hasNextPage = page.hasNextPage
            state = .loaded(updatedRows)
        } catch {
            paginationFeedback = Feedback(message: error.localizedDescription, type: .error)
        }
    }
    
    func clearPaginationFeedback() {
        paginationFeedback = nil
    }
}
