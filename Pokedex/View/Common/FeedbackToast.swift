//
//  FeedbackToast.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//

import SwiftUI

struct FeedbackToast: View {

    let feedback: Feedback

    var body: some View {
        HStack(spacing: Theme.Spacing.s) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(
                    width: Theme.Spacing.l,
                    height: Theme.Spacing.l
                )

            Text(feedback.message)
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

    private var icon: String {
        switch feedback.type {
        case .success:
            "checkmark.circle.fill"

        case .warning:
            "exclamationmark.triangle.fill"

        case .error:
            "xmark.circle.fill"
        }
    }

    private var color: Color {
        switch feedback.type {
        case .success:
            Theme.Color.success

        case .warning:
            Theme.Color.alert

        case .error:
            Theme.Color.error
        }
    }
}

#Preview {
    FeedbackToast(
        feedback: Feedback(
            message: "Pokémon adicionado ao time!",
            type: .success
        )
    )
}
