import SwiftUI

struct PokemonStatCard: View {

    let title: String
    let value: Int

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            Text(title)
                .font(Theme.Font.body)

            Text("\(value)")
                .font(.title)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .stroke(
                    Theme.Color.secondaryText.opacity(0.5),
                    lineWidth: 1
                )
        }
    }
}