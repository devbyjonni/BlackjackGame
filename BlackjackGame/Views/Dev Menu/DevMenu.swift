//
//  DevMenu.swift
//  BlackjackGame
//
//  Created by Jonni Akesson on 2025-06-05.
//

import SwiftUI

struct DevMenu: View {
    @Binding var isVisible: Bool
    @Binding var animationSpeed: AnimationSpeed
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            if isVisible {
                VStack(alignment: .leading, spacing: 12) {
                    DevMenuLabel(text: "DEV MENU")
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    SegmentedControlView(selection: $animationSpeed)
                        .frame(width: 180)
                    
                    DevMenuButton(title: "Game Completed", color: .red) {
                        NotificationCenter.default.post(name: .devGameEnd, object: nil)
                    }

                    DevMenuButton(title: "Start Dealing") {
                        NotificationCenter.default.post(name: .devStartDealing, object: nil)
                    }

                    DevMenuButton(title: "Deal One Card") {
                        NotificationCenter.default.post(name: .devDealOneCard, object: nil)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(12)
                .shadow(radius: 8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            Button {
                withAnimation {
                    isVisible.toggle()
                }
            } label: {
                Text("DEV")
                    .font(.caption).bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(radius: 4)
            }
        }
        .padding(.trailing, 16)
        .padding(.bottom, 20)
        .frame(width: 220, alignment: .trailing)
    }
}

struct DevMenuButton: View {
    let title: String
    var color: Color = .blue
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption2)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(color)
                .cornerRadius(8)
        }
        .contentShape(Rectangle())
    }
}

struct DevMenuLabel: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(.caption2)
            .bold()
            .foregroundColor(.white)
    }
}

extension Notification.Name {
    static let devGameEnd = Notification.Name("devGameEnd")
    static let devStartDealing = Notification.Name("devStartDealing")
    static let devDealOneCard = Notification.Name("devDealOneCard")
}
