import SwiftUI

struct FloatingDevMenu: View {
    @Binding var isVisible: Bool
    @Binding var animationSpeed: AnimationSpeed

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            if isVisible {
                VStack(alignment: .leading, spacing: 12) {
                    Text("DEV MENU")
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.white)

                    Divider()
                        .background(Color.white.opacity(0.2))

                    SegmentedControlView(selection: $animationSpeed)
                        .frame(width: 180)
                    Button(action: {
                        NotificationCenter.default.post(name: .simulateGameEnd, object: nil)
                    }) {
                        Text("Game Completed")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10) // ⬅️ slightly more padding for better tap target
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .contentShape(Rectangle()) // ⬅️ makes sure whole frame is tappable
                
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

extension Notification.Name {
    static let simulateGameEnd = Notification.Name("simulateGameEnd")
}
