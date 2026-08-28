//
//  CurvedBackgroundShape.swift
//  Pokedex
//
//  Created by izadora montenegro on 28/08/26.
//
import SwiftUI

struct CurvedBackgroundShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: .zero)

        path.addLine(
            to: CGPoint(
                x: rect.maxX,
                y: rect.minY
            )
        )

        path.addLine(
            to: CGPoint(
                x: rect.maxX,
                y: rect.height * 0.6
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: rect.minX,
                y: rect.height * 0.6
            ),
            control: CGPoint(
                x: rect.midX,
                y: rect.height
            )
        )

        path.closeSubpath()

        return path
    }
}

#Preview {
    CurvedBackgroundShape()
        .ignoresSafeArea(.all)
        .frame(height: 350)
}
