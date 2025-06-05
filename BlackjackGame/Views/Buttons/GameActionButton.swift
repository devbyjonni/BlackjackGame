//
//  GameActionButton.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-02-15.
//

import SwiftUI

/// A reusable button component for game actions (Hit, Stand, Deal).
struct GameActionButton: View {
    var title: String
    var color: Color
    var action: () -> Void

    var body: some View {
        Button(action: {
            withAnimation {
                action()
            }
        }) {
            Text(title.uppercased())
                .font(.title)
                .bold()
                .foregroundStyle(.white)
                .frame(width: 150, height: 70)
                .background(color)
                .cornerRadius(10)
        }
    }
}
