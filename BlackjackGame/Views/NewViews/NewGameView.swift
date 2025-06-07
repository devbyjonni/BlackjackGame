import SwiftUI

struct NewGameView: View {
    @State private var showDevMenu = false
    @State private var animationSpeed: AnimationSpeed = .medium
    @State private var playerCards: [Card] = []
    @State private var dealerCards: [Card] = []
    @State private var isGameOver = false
    @State private var isCollapsing = false
    @State private var currentIndex = 0 // 🔹 Tracks next card to deal

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
            VStack(spacing: 20) {
                Spacer()
                
                Text("Logo View Goes Here")
                    .frame(height: 50)

                Spacer()

                PlayerHandCardStackView(
                    cards: playerCards,
                    cardWidth: cardWidth,
                    isGameOver: isGameOver,
                    isCollapsing: isCollapsing
                )

                Spacer()

                GameButton(title: "Start Dealing") {
                    dealOpeningCards()
                }

                GameButton(title: "Deal One Card") {
                    dealOneCardToPlayer()
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

    private func dealOneCardToPlayer() {
        guard currentIndex < fullDeck.count else { return }

        let card = fullDeck[currentIndex]
        currentIndex += 1

        withAnimation {
            playerCards.append(clone(card))
        }
    }

    private func dealOpeningCards() {
        let delayUnit = animationSpeed.delay
        playerCards = []
        dealerCards = []
        currentIndex = 0

        func addCard(_ card: Card, to hand: Binding<[Card]>, after delay: TimeInterval) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation {
                    hand.wrappedValue.append(clone(card))
                }
            }
        }

        addCard(fullDeck[0], to: $playerCards, after: delayUnit * 1)
        addCard(fullDeck[4], to: $dealerCards, after: delayUnit * 2)
        addCard(fullDeck[1], to: $playerCards, after: delayUnit * 3)
        addCard(fullDeck[5], to: $dealerCards, after: delayUnit * 4)
        addCard(fullDeck[2], to: $playerCards, after: delayUnit * 6)
        addCard(fullDeck[3], to: $playerCards, after: delayUnit * 8)
        addCard(fullDeck[6], to: $dealerCards, after: delayUnit * 10)
        addCard(fullDeck[7], to: $dealerCards, after: delayUnit * 12)
        addCard(fullDeck[8], to: $dealerCards, after: delayUnit * 14)
        addCard(fullDeck[9], to: $dealerCards, after: delayUnit * 16)
    }

    private func clone(_ card: Card) -> Card {
        Card(suit: card.suit, rank: card.rank, value: card.value)
    }

    private func endGame() {
        // 🃏 Step 1: Flip all cards face-down
        withAnimation(.easeInOut(duration: 0.6)) {
            isGameOver = true
        }

        // 🎯 Step 2: Collapse cards to center (after flip is visible)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeInOut(duration: 0.6)) {
                isCollapsing = true
            }
        }

        // 🧹 Step 3: Slide out & reset everything
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            playerCards = []
            dealerCards = []
            isGameOver = false
            isCollapsing = false
            currentIndex = 0
        }
    }
    
  
}
