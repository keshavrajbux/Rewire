import SwiftUI

struct MoodSliderView: View {
    let title: String
    let icon: String
    @Binding var value: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Text("\(Int(value))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
                    .frame(width: 30)
                    .contentTransition(.numericText())
            }

            Slider(value: $value, in: 1...10, step: 1)
                .tint(color)
        }
        .padding()
        .cardStyle()
    }
}

#Preview {
    ZStack {
        GradientBackground()
        VStack(spacing: 12) {
            MoodSliderView(title: "Energy", icon: "bolt.fill", value: .constant(7), color: .yellow)
            MoodSliderView(title: "Mood", icon: "face.smiling", value: .constant(5), color: Theme.electricBlue)
        }
        .padding()
    }
}
