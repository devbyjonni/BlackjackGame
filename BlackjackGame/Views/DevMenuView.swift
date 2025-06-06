import SwiftUI

struct DevMenuView: View {
    @Binding var animationSpeed: AnimationSpeed

    var body: some View {
        HStack(spacing: 10) {
            Text("Dev")
                .font(.caption2)
                .bold()
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading, 6)

            Picker("", selection: $animationSpeed) {
                ForEach(AnimationSpeed.allCases) { speed in
                    Text(speed.rawValue.capitalized)
                        .font(.caption2)
                        .tag(speed)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 160)
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        .padding(.trailing, 16)
        .padding(.bottom, 24)
    
    }
}
