import SwiftUI

struct StreakRingView: View {
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
    let progress: Double

    @State private var animatedProgress: Double = 0
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .stroke(Theme.electricBlue.opacity(0.1), lineWidth: 30)
                .frame(width: 240, height: 240)

            // Background ring
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 12)
                .frame(width: 240, height: 240)

            // Progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    Theme.streakRingGradient,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 240, height: 240)
                .rotationEffect(.degrees(-90))
                .shadow(color: Theme.electricBlue.opacity(0.5), radius: 8)

            // Inner content
            VStack(spacing: 4) {
                Text("\(days)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

                Text(days == 1 ? "DAY" : "DAYS")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textSecondary)
                    .tracking(3)

                Text(timeString)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundStyle(Theme.electricBlue)
                    .padding(.top, 4)
            }
            .scaleEffect(pulseScale)
        }
        .onAppear {
            withAnimation(.spring(duration: 1.2)) {
                animatedProgress = progress
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulseScale = 1.03
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(duration: 0.5)) {
                animatedProgress = newValue
            }
        }
    }

    private var timeString: String {
        String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    ZStack {
        GradientBackground()
        StreakRingView(days: 14, hours: 6, minutes: 32, seconds: 45, progress: 0.47)
    }
}
