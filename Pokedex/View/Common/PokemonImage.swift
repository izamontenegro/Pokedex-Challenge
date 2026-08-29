import SwiftUI

/// Imagem de um Pokémon, baixada da URL. Mostra um marcador enquanto não há
/// imagem — inclusive quando a URL é `nil`.
///
/// TODO (bônus): `AsyncImage` não guarda nada em memória: rolar a lista para
/// cima e para baixo refaz o download. A própria PokéAPI pede, na política de
/// uso justo, que os clientes façam cache local dos recursos.
import SwiftUI

struct PokemonImage: View {

    let url: URL?

    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                placeholder
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }

    private var placeholder: some View {
        Image(systemName: "questionmark.circle")
            .resizable()
            .scaledToFit()
            .foregroundStyle(Theme.Color.secondaryText)
            .padding(Theme.Spacing.xs)
    }

    private func loadImage() async {
        guard let url else { return }

        if let cachedImage = ImageCache.shared.image(for: url) {
            image = cachedImage
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let downloadedImage = UIImage(data: data) else { return }

            ImageCache.shared.insert(downloadedImage, for: url)
            image = downloadedImage
        } catch {
            return
        }
    }
}
