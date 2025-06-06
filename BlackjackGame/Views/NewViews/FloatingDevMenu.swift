import SwiftUI

struct FloatingDevMenu: View {
    @Binding var isVisible: Bool
    @Binding var animationSpeed: AnimationSpeed

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            if isVisible {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Dev Menu")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.gray)

                    Divider()
                        .background(Color.white.opacity(0.2))

                    Picker("Speed", selection: $animationSpeed) {
                        ForEach(AnimationSpeed.allCases) { speed in
                            Text(speed.rawValue.capitalized).tag(speed)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .tint(.white) // ✅ clean + readable inside dark menu
                    .frame(width: 180)
                    
                }
                .padding()
                .background(Color.black)
                .opacity(0.7)
                .cornerRadius(12)
                .shadow(radius: 8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
    
            }

            Button(action: {
                withAnimation {
                    isVisible.toggle()
                }
            }) {
                Text("DEV")
                    .font(.caption).bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial) // ✅ glossy system feel
                    .cornerRadius(10)
                    .shadow(radius: 4)
            }
        }
        .padding(.trailing, 16)
        .padding(.bottom, 20)
        .frame(width: 220, alignment: .trailing)
    }
}
