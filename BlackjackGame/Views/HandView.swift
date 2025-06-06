//
//  HandView.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-02-15.
//

import SwiftUI

/// A SwiftUI view that represents a player's or dealer's hand in the Blackjack game.
struct HandView: View {
    
    // MARK: - Properties
    
    /// The title of the hand, such as `"Player"` or `"Dealer"`.
    let title: String
    
    /// The `Hand` object containing the player's or dealer's cards.
    let hand: Hand
    
    /// A Boolean value indicating whether the game is over (`true`) or still in progress (`false`).
    /// This determines whether the dealer's full hand value is displayed or only their face-up card.
    let gameOver: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            
            // MARK: - Hand Title
            
            /// Displays the title of the hand (e.g., "Player" or "Dealer").
            Text(title)
                .foregroundStyle(.white)
            
            // MARK: - Hand Value
            
            /// Displays the total value of the hand.
            /// - If `gameOver == true`, the full hand value is shown.
            /// - If `gameOver == false`, only the face-up card's value is displayed for the dealer.
            Text(gameOver ? "\(hand.value)" : "\(hand.cards.last?.value ?? 0)")
                .font(.title)
                .bold()
                .foregroundStyle(.white)
            
            // MARK: - Card Display
            
            /// Displays the cards in the hand.
            /// - The first card of the dealer's hand is face-down unless the game is over.
            HStack {
                ForEach(hand.cards.indices, id: \.self) { index in
                    CardView(card: hand.cards[index], isFaceUp: gameOver || index != 0)
                        .transition(.move(edge: .top)) // ✅ Slide down from top
                        .animation(.easeOut.delay(Double(index) * 0.15), value: hand.cards.count) // ✅ Staggered animation
                }
            }
        }
    }
}
