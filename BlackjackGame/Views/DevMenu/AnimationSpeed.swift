//
//  AnimationSpeed.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-06-05.
//

import Foundation

enum AnimationSpeed: String, CaseIterable, Identifiable {
    case slow = "Slow"
    case medium = "Medium"
    case fast = "Fast"

    var id: String { rawValue }

    var delay: TimeInterval {
        switch self {
        case .slow: return 0.6
        case .medium: return 0.3
        case .fast: return 0.15
        }
    }
}
