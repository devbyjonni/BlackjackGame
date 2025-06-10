//
//  GameStatusView.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-06-05.
//

import SwiftUI

struct GameStatusView: View {
    let message: String
    @Binding var isVisible: Bool
    
    var body: some View {
        if isVisible {
            VStack {
                Text(message)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .opacity(isVisible ? 1 : 0)
                    .transition(.scale)
                    .animation(.easeInOut(duration: 0.5), value: isVisible)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3).ignoresSafeArea())
            .onTapGesture {
                isVisible = false
            }
        }
    }
}
