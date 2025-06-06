//
//  GameManager.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-06-05.
//

import Foundation
import Observation
import SwiftUI

@Observable
class GameManager {
    private(set) var playerHand = Hand()
    private(set) var dealerHand = Hand(isDealer: true)
    private(set) var deck = Deck()
    private(set) var gameOver = false
    private(set) var scoreHistory: [String] = []
    
    var statusMessage: String = "♤ BLACKJACK"
    var hideButtons = false
    
    private let dealerCheckDelay: Double = 1.0
    private let resetDelay: Double = 1.2
    private let messageDelay: Double = 0.8

    func startGame() {
        gameOver = false
        hideButtons = false
        playerHand.reset()
        dealerHand.reset()
        deck.resetDeck()
        deck.shuffle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.playerHand.addCards(self.deck.deal(2))
                self.dealerHand.addCards(self.deck.deal(2))
            }
        }
    }

    func playerHit() {
        playerHand.addCards(deck.deal(1))
        checkPlayerStatus()
    }

    func playerStand(completion: @escaping () -> Void) {
        hideButtons = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            while self.dealerHand.value < 17 {
                self.dealerHand.addCards(self.deck.deal(1))
            }
            self.evaluateGame()
            DispatchQueue.main.asyncAfter(deadline: .now() + self.resetDelay) {
                self.startGame()
                completion()
            }
        }
    }

    private func checkPlayerStatus() {
        if playerHand.isBlackjack {
            statusMessage = "🎉 BLACKJACK! YOU WIN! 🃏🔥"
            gameOver = true
            scoreHistory.append("BJ")
        } else if playerHand.isBusted {
            statusMessage = "💥 PLAYER BUSTED! 💀"
            gameOver = true
            scoreHistory.append("B")
        }
    }

    private func evaluateGame() {
        gameOver = true
        if dealerHand.isBusted {
            statusMessage = "🚨 DEALER BUSTED! YOU WIN! 🎉"
            scoreHistory.append("P")
        } else if dealerHand.value > playerHand.value {
            statusMessage = "😞 DEALER WINS."
            scoreHistory.append("D")
        } else if dealerHand.value == playerHand.value {
            statusMessage = "🤝 IT'S A TIE!"
        } else {
            statusMessage = "🎊 YOU WIN! 🏆"
            scoreHistory.append("P")
        }
    }
}
