import SwiftUI

struct HandCardStackView: View {
    let cards: [Card]
    let cardWidth: CGFloat
    var isGameOver: Bool = false
    var isCollapsing: Bool = false

    var body: some View {
        let overlap: CGFloat = isCollapsing ? cardWidth * 0.05 : cardWidth * 0.25
        let extraCards = max(0, cards.count - 2)
        let extraOffset = CGFloat(extraCards) * overlap / 2
        let visibleCards = 2
        let handWidth = cardWidth + CGFloat(max(0, visibleCards - 1)) * overlap
        let totalOffset = handWidth / 2 - cardWidth / 2

        ZStack {
            ForEach(cards) { card in
                let index = cards.firstIndex(of: card) ?? 0
                let isFixed = index < 2
                let xOffset: CGFloat = isFixed
                    ? CGFloat(index) * overlap - totalOffset
                    : CGFloat(index) * overlap - totalOffset

                CardView(card: card, isFaceUp: true)
                    .frame(width: cardWidth)
                    .offset(x: xOffset)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .offset(x: isGameOver ? -UIScreen.main.bounds.width : (cards.count > 2 ? -extraOffset : 0))
        .opacity(isGameOver ? 0 : 1)
        .animation(.easeInOut(duration: 0.6), value: isCollapsing)
        .animation(.easeInOut(duration: 0.8), value: isGameOver)
        .frame(maxWidth: .infinity, maxHeight: 200)
    }
}
