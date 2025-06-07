import SwiftUI

struct PlayerHandCardStackView: View {
    let cards: [Card]
    let cardWidth: CGFloat
    var isGameOver: Bool = false
    var isCollapsing: Bool = false
    
    private let overlap: CGFloat = 30
    private let cardHeight: CGFloat = 180
    private let spacing: CGFloat = 20 // Used when player has exactly 2 cards
    
    var body: some View {
        GeometryReader { geo in
            let centerX = geo.size.width / 2
            let centerY = geo.size.height / 2
            
            /// 🧠 Calculate card x-positions based on count and layout rules
            let cardPositions: [CGFloat] = {
                let count = cards.count
                
                // Dynamic spacing factor that tightens as more cards are added
                let spacingFactor: CGFloat = {
                    switch count {
                    case 1: return 0
                    case 2: return spacing
                    case 3...: return overlap * (1 - CGFloat(count - 2) * 0.05)
                    default: return overlap * 0.8
                    }
                }()
                
                switch count {
                case 1:
                    return [centerX] // Dead center for a single card
                    
                case 2:
                    return [
                        centerX - spacingFactor / 2,
                        centerX + spacingFactor / 2
                    ] // Even spacing for two cards
                    
                case 3...:
                    let totalWidth = spacingFactor * CGFloat(count - 1)
                    let startX = centerX - totalWidth / 2
                    return (0..<count).map { index in
                        startX + CGFloat(index) * spacingFactor
                    }
                    
                default:
                    return [] // Shouldn’t really happen
                }
            }()
            
            ZStack {
                // 🃏 Render cards
                ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                    FlipCardView(card: card, width: cardWidth, height: cardHeight, delay: Double(index) * 0.2)
                        .frame(width: cardWidth, height: cardHeight)
                        .rotationEffect(.degrees(rotationAngle(for: index)))
                        .offset(y: yOffset(for: index))
                        .position(
                            x: isCollapsing ? centerX : cardPositions[index],
                            y: centerY
                        )
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .opacity
                        ))
                        .animation(
                            isCollapsing || isGameOver
                            ? .easeInOut(duration: 0.6)
                            : .easeOut(duration: 0.4).delay(Double(index) * 0.2),
                            value: cards.count
                        )
                }
                
                // 🎯 Red debug frame showing true center
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: 4)
                    .frame(width: cardWidth, height: cardHeight)
                    .position(x: centerX, y: centerY)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        
    }
    /// Small angle twist per card for a natural feel
    private func rotationAngle(for index: Int) -> Double {
        let baseAngles: [Double] = [-2, -1, 0, 1, 2]
        return baseAngles[index % baseAngles.count]
    }
    
    /// Subtle vertical offset for variety
    private func yOffset(for index: Int) -> CGFloat {
        let offsets: [CGFloat] = [-3, 0, 2, -1, 1]
        return offsets[index % offsets.count]
    }
}


struct FlipCardView: View {
    let card: Card
    let width: CGFloat
    let height: CGFloat
    let delay: Double
    
    @State private var isFaceUp = false
    @State private var rotation: Double = 180 // Starts face-down
    
    var body: some View {
        ZStack {
            CardView(card: card, isFaceUp: isFaceUp)
        }
        .frame(width: width, height: height)
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                rotation = 0
                isFaceUp = true
            }
        }
    }
}
