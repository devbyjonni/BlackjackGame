//
//  CardView.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-02-15.
//

import SwiftUI

/// A SwiftUI view that represents a playing card, either face-up or face-down.
struct CardView: View {
    
    // MARK: - Properties
    
    /// The card to be displayed in this view.
    let card: Card
    
    /// Determines whether the card should be displayed face-up (`true`) or face-down (`false`).
    let isFaceUp: Bool

    // MARK: - Body
    
    var body: some View {
        
        /// A dictionary that maps card rank abbreviations to their full names.
        /// This ensures that the correct image name is used when rendering a card.
        let rankMapping: [String: String] = [
            "A": "Ace",
            "2": "Two",
            "3": "Three",
            "4": "Four",
            "5": "Five",
            "6": "Six",
            "7": "Seven",
            "8": "Eight",
            "9": "Nine",
            "10": "Ten",
            "J": "Jack",
            "Q": "Queen",
            "K": "King"
        ]
        
        /// Retrieves the full name of the card's rank using the dictionary.
        /// If the rank is not found in `rankMapping`, it defaults to the original rank.
        let rankName = rankMapping[card.rank] ?? card.rank

        /// Displays the appropriate card image based on whether it's face-up or face-down.
        /// - If `isFaceUp == true`, it uses an image named `"Rank_Suit"` (e.g., `"Ace_Spades"`).
        /// - If `isFaceUp == false`, it displays the back of the card ("Face_Down_Card").
        Image(isFaceUp ? "\(rankName)_\(card.suit)" : "Face_Down_Card")
            .resizable()
            .scaledToFit()
            .frame(width: 120) // Sets the card size
            .shadow(radius: 2, x: 2, y: 2) // Adds a slight shadow for depth
    }
}
