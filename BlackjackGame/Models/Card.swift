//
//  Card.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-02-15.
//

import Foundation

struct Card: Identifiable {
    let id = UUID()
    let suit: String
    let rank: String
    let value: Int
    
    var description: String {
        "\(rank) of \(suit)"
    }
}
