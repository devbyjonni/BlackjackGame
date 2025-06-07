import SwiftUI


// MARK: - Card Animation Test View
struct CardAnimationTestView: View {
    @State private var animatedCards: [Card] = []
    @State private var cardShouldBeRemoved = false
    @State private var currentIndex = 0

    private let cardWidth: CGFloat = 120
    private let overlap: CGFloat = 40

    private let testDeck: [Card] = [
        Card(suit: "Hearts", rank: "Queen", value: 10),
        Card(suit: "Spades", rank: "Three", value: 3),
        Card(suit: "Clubs", rank: "Ten", value: 10),
        Card(suit: "Diamonds", rank: "Two", value: 2)
    ]

    var body: some View {
        VStack(spacing: 40) {
            GeometryReader { geo in
                let centerX = geo.size.width / 2
                let centerY = geo.size.height / 2

                ZStack {
                    ForEach(Array(animatedCards.enumerated()), id: \ .element.id) { index, card in
                        let totalCardStackWidth = cardWidth + CGFloat(max(0, animatedCards.count - 1)) * overlap
                        let targetX = centerX - (totalCardStackWidth / 2) + CGFloat(index) * overlap

                        AnimatedCardView(card: card, index: index, targetX: targetX, targetY: centerY, cardWidth: cardWidth)

                        Color.clear
                            .onAppear {
                                print("🟡 Appeared Card[\(index)]: \(card.rank) of \(card.suit)")
                                print("🟦 geo size: \(geo.size)")
                                print("🔵 centerX: \(centerX), centerY: \(centerY)")
                                print("🎯 targetX for Card[\(index)] = \(targetX)")
                            }
                    }

                    Rectangle()
                        .stroke(Color.blue, lineWidth: 3)
                        .frame(width: cardWidth, height: 180)
                        .position(x: centerX, y: centerY)
                }
                .background(Color.red.opacity(0.1))
            }
            .frame(height: 200)

            HStack(spacing: 30) {
                Button("Deal Card") {
                    dealCard()
                }
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Reset") {
                    cardShouldBeRemoved = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        animatedCards = []
                        currentIndex = 0
                        cardShouldBeRemoved = false
                    }
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding(.top, 60)
        .onAppear {
            print("👋 CardAnimationTestView appeared.")
        }
    }

    private func dealCard() {
        guard currentIndex < testDeck.count else { return }
        let card = testDeck[currentIndex]
        animatedCards.append(card)
        print("🃏 Dealt Card[\(currentIndex)]: \(card.rank) of \(card.suit)")
        currentIndex += 1
    }
}

// MARK: - Animated Card View
fileprivate struct AnimatedCardView: View {
    let card: Card
    let index: Int
    let targetX: CGFloat
    let targetY: CGFloat
    let cardWidth: CGFloat

    @State private var offset: CGSize = CGSize(width: 400, height: -200)
    @State private var scale: CGFloat = 1.2
    @State private var rotation: Double = -20

    var body: some View {
        CardView(card: card, isFaceUp: true)
            .frame(width: cardWidth, height: 180)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .offset(offset)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5).delay(Double(index) * 0.2)) {
                    offset = .zero
                    scale = 1.0
                    rotation = 0
                }
            }
            .position(x: targetX, y: targetY)
    }
}
