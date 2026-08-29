//
//  Feedback.swift
//  Pokedex
//
//  Created by izadora montenegro on 29/08/26.
//

import Foundation

enum FeedbackType: Equatable {
    case success
    case warning
    case error
}

struct Feedback: Equatable {
    let message: String
    let type: FeedbackType
}
