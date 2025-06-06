import SwiftUI

struct HandCardStackView: View {
    let cards: [Card]
    let cardWidth: CGFloat
    var isGameOver: Bool = false
    var isCollapsing: Bool = false
    var isDealer: Bool = false

    private let overlap: CGFloat = 30
    private let spacing: CGFloat = 50 // spacing between first two dealer cards

    var body: some View {
        let centerGapOffset: CGFloat = {
            if isDealer {
                if cards.count <= 2 {
                    // First two cards spaced evenly
                    return (cardWidth * 2 + spacing) / 2
                } else {
                    // For 3 or more cards, treat all with overlap
                    let totalWidth = cardWidth + CGFloat(cards.count - 1) * overlap
                    return totalWidth / 2 - cardWidth / 2
                }
            } else {
                let totalWidth = cardWidth + CGFloat(max(0, cards.count - 1)) * overlap
                return totalWidth / 2 - cardWidth / 2
            }
        }()

        ZStack {
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                let xOffset: CGFloat = {
                    if isCollapsing {
                        return 0
                    }
                    if isDealer {
                        if cards.count <= 2 {
                            switch index {
                            case 0:
                                return -((cardWidth + spacing) / 2)
                            case 1:
                                return ((cardWidth + spacing) / 2)
                            default:
                                return 0 // shouldn't happen
                            }
                        } else {
                            // Use overlap layout for all dealer cards
                            return CGFloat(index) * overlap - centerGapOffset
                        }
                    } else {
                        return CGFloat(index) * overlap - centerGapOffset
                    }
                }()

                CardView(card: card, isFaceUp: true)
                    .frame(width: cardWidth)
                    .offset(x: xOffset)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .offset(x: {
            if isDealer && cards.count > 2 {
                let cardLeft = CGFloat(cards.count - 2)
                let totalOverlap = cardWidth/overlap
                let shadowBuffer = 3.0
                let newX = ((totalOverlap - shadowBuffer) * cardLeft) / 2
                return newX
            } else {
                return 0
            }
        }())
        .animation(isDealer ? .easeInOut(duration: 0.6) : .none, value: isCollapsing)
        .animation(.easeInOut(duration: 0.8), value: isGameOver)
    }
}
