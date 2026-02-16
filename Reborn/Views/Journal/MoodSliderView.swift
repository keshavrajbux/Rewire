import SwiftUI

struct MoodSliderView: View {
    let title: String
    let icon: String
    @Binding var value: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 36, height: 36)

                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(color)
                }

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Theme.textPrimary)

                Spacer()

                Text("\(Int(value))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
                    .frame(width: 36)
                    .contentTransition(.numericText())
            }

            // Custom styled slider
            Slider(value: $value, in: 1...10, step: 1)
                .tint(color)
                .onChange(of: value) { _, _ in
                    // Light haptic on value change
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred(intensity: 0.3)
                }
        }
        .padding(Theme.paddingMedium)
        .cardStyle()
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        VStack(spacing: 12) {
            MoodSliderView(title: "Energy", icon: "bolt.fill", value: .constant(7), color: Theme.gold)
            MoodSliderView(title: "Confidence", icon: "shield.fill", value: .constant(6), color: Theme.successGreen)
            MoodSliderView(title: "Focus", icon: "eye.fill", value: .constant(8), color: Theme.neonBlue)
            MoodSliderView(title: "Mood", icon: "heart.fill", value: .constant(5), color: Theme.royalViolet)
        }
        .padding()
    }
}
