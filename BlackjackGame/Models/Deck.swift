//
//  Deck.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-02-15.
//

import Foundation
import Observation

/// The `Deck` class represents a deck of playing cards used in the Blackjack game.
/// It is responsible for generating a full deck, shuffling, and dealing cards using RNG.
@Observable
class Deck {
    
    /// The list of cards in the deck.
    /// It is marked as `private(set)` so it can be read externally but modified only within this class.
    private(set) var cards: [Card] = []
    
    /// Stores the number of decks being used in the game.
    private let numberOfDecks: Int

    /// Defines when the deck should reshuffle (when fewer than 30% of the cards remain).
    private var reshuffleThreshold: Int {
        return (52 * numberOfDecks) / 3 // ✅ 30% of total cards
    }

    /// Initializes a new deck of cards.
    /// Calls `resetDeck()` to generate a full deck and shuffles it.
    /// - Parameter decks: The number of decks to be used (default is 6).
    init(decks: Int = 6) { // ✅ Default to 6 decks
        self.numberOfDecks = decks
        resetDeck()
        shuffle()
    }

    /// Resets the deck by generating a full set of playing cards based on the number of decks.
    /// This method does NOT shuffle the deck, allowing game logic to control shuffling.
    func resetDeck() {
        let suits = ["Spades", "Clubs", "Hearts", "Diamonds"]
        let ranks: [(String, Int)] = [
            ("Ace", 11), ("Two", 2), ("Three", 3), ("Four", 4),
            ("Five", 5), ("Six", 6), ("Seven", 7), ("Eight", 8),
            ("Nine", 9), ("Ten", 10), ("Jack", 10), ("Queen", 10), ("King", 10)
        ]

        // ✅ Generates all cards based on the number of decks used.
        cards = (0..<numberOfDecks).flatMap { _ in
            suits.flatMap { suit in
                ranks.map { rank in
                    Card(suit: suit, rank: rank.0, value: rank.1)
                }
            }
        }
    }

    /// Shuffles the deck using a cryptographic RNG for better randomness.
    /// This ensures true unpredictability in card order.
    func shuffle() {
        var rng = SystemRandomNumberGenerator()
        cards.shuffle(using: &rng) // ✅ Uses a secure random generator
    }

    /// Deals a specified number of cards from the deck.
    /// Automatically reshuffles if the deck is running low (below 30%).
    /// - Parameter number: The number of cards to deal.
    /// - Returns: An array of `Card` objects representing the dealt cards.
    func deal(_ number: Int) -> [Card] {
        // ✅ If deck has fewer than 30% of cards left, reshuffle (like in casinos)
        if cards.count < reshuffleThreshold {
            resetDeck()
            shuffle()
        }

        guard number <= cards.count else { return [] }

        let dealtCards = Array(cards.prefix(number))
        cards.removeFirst(number)

        return dealtCards
    }

    /// Draws a completely random card from the deck instead of taking from the top.
    /// - Returns: A randomly drawn `Card`, or `nil` if the deck is empty.
    func drawRandomCard() -> Card? {
        guard !cards.isEmpty else { return nil }
        let randomIndex = Int.random(in: 0..<cards.count) // ✅ Picks a truly random index
        return cards.remove(at: randomIndex)
    }
}
