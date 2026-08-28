//
//  FeedbackToast.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//

import SwiftUI

struct FeedbackToast: View {

    let message: String

    var body: some View {
        HStack(spacing: Theme.Spacing.s) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Theme.Color.alert)
                .frame(
                    width: Theme.Spacing.l,
                    height: Theme.Spacing.l
                )

            Text(message)
                .font(Theme.Font.caption)
                .foregroundStyle(Theme.Color.primaryText)
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, Theme.Spacing.s)
        .padding(.horizontal, Theme.Spacing.m)
        .background(Theme.Color.surface)
        .clipShape(Capsule())
        .shadow(
            color: .black.opacity(0.1),
            radius: 6,
            x: 0,
            y: 2
        )
    }
}

#Preview {
    FeedbackToast(message: "Erro ao carregar dados")
}
