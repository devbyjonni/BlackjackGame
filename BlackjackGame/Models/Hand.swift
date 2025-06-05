//
//  Hand.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-02-15.
//

import Foundation
import Observation

/// The `Hand` class represents a player's or dealer's hand in a Blackjack game.
/// It manages cards, calculates hand value, and determines game conditions like Blackjack or Bust.
@Observable
class Hand {
    
    /// The list of cards in the hand.
    /// Uses `didSet` to automatically update the hand value whenever cards change.
    var cards: [Card] = [] {
        didSet {
            updateValue() // Updates the total hand value whenever cards are added or removed.
        }
    }
    
    /// Checks if the hand is a Blackjack (21 with only two cards).
    var isBlackjack: Bool {
        cards.count == 2 && value == 21
    }
    
    /// Indicates whether this hand belongs to the dealer (`true`) or the player (`false`).
    var isDealer: Bool
    
    /// Stores the computed value of the hand.
    /// This avoids recalculating the value every time it's accessed, improving efficiency.
    private(set) var value: Int = 0

    /// Checks if the hand has exceeded 21 (busted).
    var isBusted: Bool { value > 21 }
    
    /// Initializes a new `Hand` instance.
    /// - Parameter isDealer: A Boolean indicating whether this hand belongs to the dealer.
    init(isDealer: Bool = false) {
        self.isDealer = isDealer
    }
    
    /// Adds new cards to the hand.
    /// - Parameter newCards: The cards to add to the hand.
    func addCards(_ newCards: [Card]) {
        cards.append(contentsOf: newCards) // Appends new cards and triggers `didSet` to update the value.
    }
    
    /// Resets the hand by clearing all cards and setting the value to 0.
    func reset() {
        cards.removeAll() // Removes all cards from the hand.
        value = 0 // Resets the hand value.
    }
    
    /// Updates the total value of the hand, taking into account Ace adjustments.
    /// Aces can be worth 11 or 1, so this method ensures that the value is adjusted correctly
    /// to prevent the hand from busting if possible.
    private func updateValue() {
        var total = 0
        var aces = 0
        
        // Calculate the total hand value and count the number of Aces.
        for card in cards {
            total += card.value
            if card.rank == "Ace" {
                aces += 1
            }
        }
        
        // If the total exceeds 21 and there are Aces, convert them from 11 to 1 as needed.
        while total > 21 && aces > 0 {
            total -= 10
            aces -= 1
        }
        
        // Store the final calculated hand value.
        value = total
    }
}
