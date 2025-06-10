//
//  CenteredCardStackView.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-06-05.
//

import SwiftUI

struct CenteredCardStackView: View {
    let height: CGFloat
    let cards: [Card]
    let cardWidth: CGFloat
    var isGameOver: Bool = false

    private let overlap: CGFloat = 40
    private let cardHeight: CGFloat = 180

    var body: some View {
        GeometryReader { geo in
            let centerX = geo.size.width / 2
            let centerY = geo.size.height / 2

            ZStack {
                ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                    FlipCardView(card: card, width: cardWidth, height: cardHeight)
                        .frame(width: cardWidth, height: cardHeight)
                        .rotationEffect(.degrees(rotationAngle(for: index)))
                        .position(
                            x: isGameOver ? centerX : xPosition(for: index, count: cards.count, centerX: centerX, overlap: overlap),
                            y: centerY
                        )
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .opacity
                        ))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: height)
    }

    /// Small angle twist per card for a natural feel
    private func rotationAngle(for index: Int) -> Double {
        let baseAngles: [Double] = [-2, -1, 0, 1, 2]
        return baseAngles[index % baseAngles.count]
    }
    
    /// Calculates x-positions for cards based on count and overlap spacing
    private func xPosition(for index: Int, count: Int, centerX: CGFloat, overlap: CGFloat) -> CGFloat {
        /// Reduces spacing slightly as more cards are added to avoid overflow
        let spacingTighteningFactor: CGFloat = 0.05
        /// Maximum overlap ratio used when card count is high (fallback layout)
        let maxOverlapMultiplier: CGFloat = 0.8
        /// Used to center two cards evenly around the middle (±0.5 * spacing)
        let halfSpacingMultiplier: CGFloat = 0.5

        let spacingFactor: CGFloat = {
            switch count {
            case 1:
                return 0
            case 2:
                return overlap
            case 3...:
                return overlap * (1 - CGFloat(count - 2) * spacingTighteningFactor)
            default:
                return overlap * maxOverlapMultiplier
            }
        }()

        switch count {
        case 1:
            return centerX - overlap * halfSpacingMultiplier
        case 2:
            return centerX + spacingFactor * (index == 0 ? -halfSpacingMultiplier : halfSpacingMultiplier)
        case 3...:
            let totalWidth = spacingFactor * CGFloat(count - 1)
            let startX = centerX - totalWidth / 2
            return startX + CGFloat(index) * spacingFactor
        default:
            return centerX
        }
    }
}
