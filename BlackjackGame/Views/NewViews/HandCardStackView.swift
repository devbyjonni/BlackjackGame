import SwiftUI

struct HandCardStackView: View {
    let cards: [Card]
    let cardWidth: CGFloat
    var isGameOver: Bool = false
    var isCollapsing: Bool = false // 👈 new param

    var body: some View {
        let overlap: CGFloat = cardWidth * 0.25
        let handWidth = cardWidth + CGFloat(max(0, cards.count - 1)) * overlap
        let totalOffset = handWidth / 2 - cardWidth / 2

        ZStack {
            ForEach(cards) { card in
                CardView(card: card, isFaceUp: true)
                    .frame(width: cardWidth)
                    .offset(x: isCollapsing
                            ? 0 // 👈 all cards collapse to center
                            : CGFloat(cards.firstIndex(of: card) ?? 0) * overlap - totalOffset)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .offset(x: isGameOver ? -UIScreen.main.bounds.width : 0)
        .opacity(isGameOver ? 0 : 1)
        .animation(.easeInOut(duration: 0.6), value: isCollapsing)
        .animation(.easeInOut(duration: 0.8), value: isGameOver)
    }
}
