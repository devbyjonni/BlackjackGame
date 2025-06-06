import SwiftUI

struct HandCardStackView: View {
    let cards: [Card]
    let cardWidth: CGFloat

    var body: some View {
        let overlap: CGFloat = cardWidth * 0.25
        let extraCards = max(0, cards.count - 2)
        let extraOffset = CGFloat(extraCards) * overlap / 2
        let visibleCards = 2
        let handWidth = cardWidth + CGFloat(max(0, visibleCards - 1)) * overlap
        let totalOffset = handWidth / 2 - cardWidth / 2

        ZStack {
            ForEach(cards) { card in
                CardView(card: card, isFaceUp: true)
                    .frame(width: cardWidth)
                    .offset(x: CGFloat(cards.firstIndex(of: card) ?? 0) * overlap - totalOffset)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .offset(x: cards.count > 2 ? -extraOffset : 0)
        .frame(maxWidth: .infinity, maxHeight: 200)
    }
}
