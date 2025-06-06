import SwiftUI

struct NewGameView: View {
    @State private var showDevMenu = false
    @State private var animationSpeed: AnimationSpeed = .medium
    @State private var playerCards: [Card] = []
    @State private var dealerCards: [Card] = []
    @State private var isGameOver = false
    @State private var isCollapsing = false

    private let cardWidth: CGFloat = 100

    private let fullDeck: [Card] = [
        Card(suit: "Spades", rank: "Ace", value: 11),
        Card(suit: "Hearts", rank: "King", value: 10),
        Card(suit: "Clubs", rank: "Six", value: 6),
        Card(suit: "Diamonds", rank: "Three", value: 3),
        Card(suit: "Diamonds", rank: "Queen", value: 10),
        Card(suit: "Clubs", rank: "Seven", value: 7)
    ]

    var body: some View {
        ZStack {
            VStack {
                HandCardStackView(cards: dealerCards, cardWidth: cardWidth, isGameOver: isGameOver, isCollapsing: isCollapsing)
                Spacer()
                Text("Logo View Goes Here")
                    .frame(height: 50)
                Spacer()
                HandCardStackView(cards: playerCards, cardWidth: cardWidth, isGameOver: isGameOver, isCollapsing: isCollapsing)
                Spacer()
                GameButton(title: "Start Dealing") {
                    dealOpeningCards()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Custom_Green"))
        }
        .overlay(alignment: .bottomTrailing) {
            FloatingDevMenu(isVisible: $showDevMenu, animationSpeed: $animationSpeed)
        }
        .onReceive(NotificationCenter.default.publisher(for: .simulateGameEnd)) { _ in
            endGame()
        }
    }
    
    private func endGame() {
        withAnimation {
            isCollapsing = true
        }

        // Wait for collapse first
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                isGameOver = true
            }
        }

        // Wait for slide out, then reset cards
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            playerCards = []
            dealerCards = []
            isGameOver = false
            isCollapsing = false
        }
    }

    private func dealOpeningCards() {
        let delayUnit = animationSpeed.delay
        playerCards = []
        dealerCards = []

        func addCard(_ card: Card, to hand: Binding<[Card]>, after delay: TimeInterval) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation {
                    hand.wrappedValue.append(clone(card)) // ✅ fresh UUID!
                }
            }
        }

        addCard(fullDeck[0], to: $playerCards, after: delayUnit * 1)
        addCard(fullDeck[4], to: $dealerCards, after: delayUnit * 2)
        addCard(fullDeck[1], to: $playerCards, after: delayUnit * 3)
        addCard(fullDeck[5], to: $dealerCards, after: delayUnit * 4)
        addCard(fullDeck[2], to: $playerCards, after: delayUnit * 6)
        addCard(fullDeck[3], to: $playerCards, after: delayUnit * 8)
    }

    private func clone(_ card: Card) -> Card {
        Card(suit: card.suit, rank: card.rank, value: card.value)
    }
}
