//
//  NewGameView.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-06-05.
//

import SwiftUI

struct NewGameView: View {
    @State private var showDevMenu = false
    @State private var animationSpeed: AnimationSpeed = .medium
    @State private var cards: [Card] = []
    @State private var isGameOver = false
    @State private var currentIndex = 0
    @State private var isDealing = false
    
    private let cardWidth: CGFloat = 100
    
    private let fullDeck: [Card] = [
        Card(suit: "Spades", rank: "Ace", value: 11),
        Card(suit: "Hearts", rank: "King", value: 10),
        Card(suit: "Clubs", rank: "Six", value: 6),
        Card(suit: "Diamonds", rank: "Three", value: 3),
        Card(suit: "Diamonds", rank: "Queen", value: 10),
        Card(suit: "Clubs", rank: "Seven", value: 7),
        Card(suit: "Spades", rank: "Five", value: 5),
        Card(suit: "Hearts", rank: "Two", value: 2),
        Card(suit: "Clubs", rank: "Nine", value: 9),
        Card(suit: "Hearts", rank: "Four", value: 4)
    ]
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Logo View Goes Here")
                    .frame(height: 50)
                Spacer()
                FanCardsView(
                    height: 200,
                    cards: cards,
                    cardWidth: cardWidth,
                    isGameOver: isGameOver
                )
                Spacer()
                GameButton(title: "Start Dealing") {
                    dealTwoOpeningCards()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Custom_Green"))
        }
        .overlay(alignment: .bottomTrailing) {
            DevMenu(isVisible: $showDevMenu, animationSpeed: $animationSpeed)
        }
        .onReceive(NotificationCenter.default.publisher(for: .devGameEnd)) { _ in
            endGame()
        }
        .onReceive(NotificationCenter.default.publisher(for: .devStartDealing)) { _ in
            dealAllOpeningCards()
        }
        .onReceive(NotificationCenter.default.publisher(for: .devDealOneCard)) { _ in
            dealOneCardToPlayer()
        }
    }
    
    private func dealOneCardToPlayer() {
        guard !isDealing, currentIndex < fullDeck.count else { return }
        isDealing = true
        
        let card = fullDeck[currentIndex]
        currentIndex += 1
        
        withAnimation {
            cards.append(card)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            isDealing = false
        }
    }
    
    private func dealTwoOpeningCards() {
        guard !isDealing else { return }
        isDealing = true
        
        let delayUnit = animationSpeed.delay
        cards = []
        currentIndex = 0
        
        func addCard(_ card: Card, after delay: TimeInterval) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation {
                    cards.append(card)
                }
                if delay == delayUnit * 2 {
                    isDealing = false
                }
            }
        }
        
        addCard(fullDeck[0], after: delayUnit * 1)
        addCard(fullDeck[4], after: delayUnit * 2)
    }
    
    private func dealAllOpeningCards() {
        guard !isDealing else { return }
        isDealing = true
        
        let delayUnit = animationSpeed.delay
        cards = []
        currentIndex = 0
        
        func addCard(_ card: Card, to hand: Binding<[Card]>, after delay: TimeInterval, isLast: Bool = false) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation {
                    hand.wrappedValue.append(clone(card))
                }
                if isLast {
                    isDealing = false
                }
            }
        }
        
        addCard(fullDeck[0], to: $cards, after: delayUnit * 1)
        addCard(fullDeck[4], to: $cards, after: delayUnit * 2)
        addCard(fullDeck[1], to: $cards, after: delayUnit * 3)
        addCard(fullDeck[5], to: $cards, after: delayUnit * 4, isLast: true)
    }
    
    private func clone(_ card: Card) -> Card {
        Card(suit: card.suit, rank: card.rank, value: card.value)
    }
    
    private func endGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeInOut(duration: 0.6)) {
                isGameOver = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            cards = []
            isGameOver = false
            currentIndex = 0
        }
    }
}
