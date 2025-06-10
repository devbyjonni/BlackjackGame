//
//  FlipCardView.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-06-10.
//

import SwiftUI

struct FlipCardView: View {
    let card: Card
    let width: CGFloat
    let height: CGFloat

    @State private var isFaceUp = false
    @State private var rotation: Double = 180 // Starts face-down

    var body: some View {
        ZStack {
            CardView(card: card, isFaceUp: isFaceUp)
        }
        .frame(width: width, height: height)
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).delay(0)) {
                rotation = 0
                isFaceUp = true
            }
        }
    }
}
