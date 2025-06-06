// HandCardStackView.swift
import SwiftUI

struct HandCardStackView: View {
    let cards: [Card]
    let cardWidth: CGFloat

    var body: some View {
        let overlap: CGFloat = cardWidth * 0.25
        let handWidth = cardWidth + CGFloat(max(0, cards.count - 1)) * overlap
        let totalOffset = handWidth / 2 - cardWidth / 2

        ZStack {
            ForEach(cards.indices, id: \.self) { index in
                CardView(card: cards[index], isFaceUp: true)
                    .frame(width: cardWidth)
                    .offset(x: CGFloat(index) * overlap - totalOffset)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
    }
}
