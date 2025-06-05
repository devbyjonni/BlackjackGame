//
//  GameView.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-01-19.
//

import SwiftUI

struct GameView: View {
    private let initialMessage = "♤ BLACKJACK"
    private let dealerCheckingMessage = "👀 Dealer is Checking Their Face-Down Card..."
    private let dealerHasBlackjackMessage = "💀 DEALER HAS BLACKJACK!"
    private let blackjackWinMessage = "🎉 BLACKJACK! YOU WIN! 🃏🔥"
    private let playerBustedMessage = "💥 PLAYER BUSTED! 💀"
    private let dealerBustedMessage = "🚨 DEALER BUSTED! YOU WIN! 🎉"
    private let playerWinsMessage = "🎊 YOU WIN! 🏆"
    private let dealerWinsMessage = "😞 DEALER WINS."
    private let tieMessage = "🤝 IT'S A TIE!"
    private let bothBlackjackMessage = "🎭 IT'S A TIE! (BOTH HAVE BLACKJACK)"
    
    private let scoreCircleSize: CGFloat = 35
    private let buttonWidth: CGFloat = 140
    private let buttonHeight: CGFloat = 55
    private let dealButtonWidth: CGFloat = 160
    
    // Improved Timing for Faster Gameplay Flow
    private let dealerCheckDelay: Double = 1.0
    private let resetDelay: Double = 1.2
    private let messageDelay: Double = 0.8
    private let dealNewCardsDelay: Double = 0.3
    
    // MARK: - Properties
    @State private var playerHand = Hand()
    @State private var dealerHand = Hand(isDealer: true)
    @State private var deck = Deck()
    @State private var gameOver = false
    @State private var scoreHistory: [String] = []
    @State private var hideButtons = false
    @State private var showGameStatus = false // ✅ Controls GameStatusView visibility
    @State private var statusMessage = "" // ✅ Stores temporary message
    @State private var message: String = "♤ BLACKJACK" // ✅ Ensures message exists
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            VStack {
                scoreboardView()
                HandView(title: "Dealer", hand: dealerHand, gameOver: gameOver)
                HandView(title: "Player", hand: playerHand, gameOver: true)
                Spacer()
                actionButtons()
                Spacer()
            }
            
            // ✅ Overlay for GameStatusView
            GameStatusView(message: statusMessage, isVisible: $showGameStatus)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Custom_Green"))
        .onAppear(perform: startGame)
    }
    
    // MARK: - Scoreboard View
    
    @ViewBuilder
    private func scoreboardView() -> some View {
        VStack {
            Text("Scoreboard History")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .bold()
                .padding(.bottom, 2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(scoreHistory.indices, id: \.self) { index in
                        let score = scoreHistory[index]
                        
                        Text(score)
                            .font(.headline)
                            .bold()
                            .frame(width: scoreCircleSize, height: scoreCircleSize)
                            .background(["P", "BJ"].contains(score) ? Color.green : Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            }
            .frame(height: 50)
            .background(Color.black.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 5)
    }
    
    // MARK: - Action Buttons
    
    @ViewBuilder
    private func actionButtons() -> some View {
        if !gameOver && !hideButtons {
            HStack(spacing: 20) {
                GameActionButton(title: "Hit", color: .black) {
                    playerHand.addCards(deck.deal(1))
                    checkGameStatus()
                }
                .frame(width: buttonWidth, height: buttonHeight)
                
                GameActionButton(title: "Stand", color: .black, action: {
                    hideButtons = true
                    dealerPlays()
                })
                .frame(width: buttonWidth, height: buttonHeight)
            }
            .padding(.top, 15)
        } else if gameOver {
            GameActionButton(title: "Deal", color: .black, action: resetGame)
                .frame(width: dealButtonWidth, height: buttonHeight)
        }
    }
    
    // MARK: - Game Logic
    
    private func startGame() {
        deck.resetDeck()
        deck.shuffle()
        
        gameOver = false
        hideButtons = false
        
        playerHand.reset()
        dealerHand.reset()
        
        playerHand.addCards(deck.deal(2))
        dealerHand.addCards(deck.deal(2))
        
        checkDealerBlackjack()
    }
    
    private func checkDealerBlackjack() {
        guard let faceUpCard = dealerHand.cards.last,
              faceUpCard.rank == "Ace" || faceUpCard.value == 10 else {
            checkGameStatus()
            return
        }
        
        hideButtons = true
        updateStatus(dealerCheckingMessage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + dealerCheckDelay) {
            let faceDownCard = dealerHand.cards.first
            
            if let card = faceDownCard, dealerHasBlackjack(card) {
                gameOver = true
                updateStatus(playerHand.isBlackjack ? bothBlackjackMessage : dealerHasBlackjackMessage)
                
                if !playerHand.isBlackjack {
                    scoreHistory.append("D")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + resetDelay) {
                    resetGame()
                }
            } else {
                updateStatus(initialMessage)
                hideButtons = false
                DispatchQueue.main.asyncAfter(deadline: .now() + messageDelay) {
                    checkGameStatus()
                }
            }
        }
    }
    
    /// Handles the dealer's turn after the player stands.
    private func dealerPlays() {
        hideButtons = true // ✅ Hide buttons as dealer plays
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { // ✅ Small delay for realism
            while dealerHand.value < 17 { // ✅ Dealer hits until 17+
                dealerHand.addCards(deck.deal(1))
            }
            
            gameOver = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { // ✅ Show results after a short delay
                if dealerHand.isBusted {
                    updateStatus(dealerBustedMessage)
                    scoreHistory.append("P") // ✅ Player wins
                } else if dealerHand.value > playerHand.value {
                    updateStatus(dealerWinsMessage)
                    scoreHistory.append("D") // ✅ Dealer wins
                } else if dealerHand.value == playerHand.value {
                    updateStatus(tieMessage)
                } else {
                    updateStatus(playerWinsMessage)
                    scoreHistory.append("P") // ✅ Player wins
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + resetDelay) {
                    resetGame()
                }
            }
        }
    }
    
    /// Checks if the dealer has Blackjack using their face-down card.
    private func dealerHasBlackjack(_ faceDownCard: Card) -> Bool {
        guard dealerHand.cards.count > 1 else { return false } // ✅ Ensure there are at least 2 cards
        
        let faceUpCard = dealerHand.cards[1] // ✅ Dealer's visible card
        
        return (faceDownCard.rank == "Ace" && faceUpCard.value == 10) ||
        (faceDownCard.value == 10 && faceUpCard.rank == "Ace")
    }
    
    private func updateStatus(_ newMessage: String) {
        statusMessage = newMessage
        showGameStatus = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + messageDelay) {
            showGameStatus = false
        }
    }
    
    /// Resets the game and starts a new round after a short delay.
    private func resetGame() {
        DispatchQueue.main.async {
            self.message = initialMessage // ✅ Keep popup visible
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + resetDelay) {
            playerHand.reset()
            dealerHand.reset() // ✅ Remove cards first, keep popup
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // ✅ Wait a bit before hiding popup
                message = "" // ✅ Hide the popup after cards are gone
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + dealNewCardsDelay + 0.8) {
                startGame() // ✅ Start new round only after everything is clean
            }
        }
    }
    
    /// Checks if the player has Blackjack or has busted.
    private func checkGameStatus() {
        if playerHand.isBlackjack {
            gameOver = true
            updateStatus("🎉 BLACKJACK! YOU WIN! 🃏🔥") // ✅ Shows emojis when player wins with BJ!
            scoreHistory.append("BJ") // ✅ Track Blackjack wins separately
            hideButtons = true
        } else if playerHand.isBusted {
            gameOver = true
            updateStatus("💥 PLAYER BUSTED! 💀") // ✅ Now uses `updateStatus()`
            scoreHistory.append("B") // ✅ Track Busts in scoreboard
            hideButtons = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + messageDelay) {
                clearTable() // ✅ Keeps the popup visible before removing cards
            }
        }
        
        if gameOver {
            resetGame()
        }
    }
    
    /// Clears the table by removing cards but keeping the popup visible.
    private func clearTable() {
        playerHand.reset()
        dealerHand.reset()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + dealNewCardsDelay) {
            resetGame() // ✅ Now resets AFTER clearing cards
        }
    }
}
