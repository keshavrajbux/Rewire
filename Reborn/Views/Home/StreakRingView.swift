import SwiftUI

struct StreakRingView: View {
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
    let progress: Double

    @State private var animatedProgress: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var ambientGlow: CGFloat = 0.3
    @State private var isVisible = false

    private let ringSize: CGFloat = Constants.Layout.streakRingSize
    private let lineWidth: CGFloat = Constants.Layout.streakRingLineWidth

    var body: some View {
        ZStack {
            // Ambient background glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Theme.neonBlue.opacity(ambientGlow * 0.3),
                            Theme.royalViolet.opacity(ambientGlow * 0.15),
                            .clear
                        ],
                        center: .center,
                        startRadius: ringSize * 0.3,
                        endRadius: ringSize * 0.8
                    )
                )
                .frame(width: ringSize * 1.3, height: ringSize * 1.3)
                .blur(radius: 30)

            // Outer glow ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            Theme.neonBlue.opacity(0.15),
                            Theme.royalViolet.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 30
                )
                .frame(width: ringSize, height: ringSize)
                .blur(radius: 10)

            // Background ring track
            Circle()
                .stroke(Theme.textPrimary.opacity(0.1), lineWidth: lineWidth)
                .frame(width: ringSize, height: ringSize)

            // Progress ring with glow
            ZStack {
                // Glow layer
                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(
                        Theme.streakRingGradient,
                        style: StrokeStyle(lineWidth: lineWidth + 8, lineCap: .round)
                    )
                    .frame(width: ringSize, height: ringSize)
                    .rotationEffect(.degrees(-90))
                    .blur(radius: 8)
                    .opacity(0.6)

                // Main ring
                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(
                        Theme.streakRingGradient,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .frame(width: ringSize, height: ringSize)
                    .rotationEffect(.degrees(-90))
            }
            .shadow(color: Theme.neonBlue.opacity(0.5), radius: 12)
            .shadow(color: Theme.royalViolet.opacity(0.3), radius: 20)

            // Inner content
            VStack(spacing: 6) {
                // Day counter with gradient
                Text("\(days)")
                    .font(Theme.Typography.heroDisplay)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Theme.textPrimary, Theme.textSecondary],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .contentTransition(.numericText())
                    .shadow(color: Theme.sunnyYellow.opacity(0.3), radius: 10)

                // Label
                Text(days == 1 ? "DAY" : "DAYS")
                    .font(Theme.Typography.credits)
                    .foregroundStyle(Theme.textSecondary)
                    .tracking(4)

                // Time display
                Text(timeString)
                    .font(Theme.Typography.timerMono)
                    .foregroundStyle(Theme.neonBlue)
                    .padding(.top, 8)
                    .contentTransition(.numericText())
            }
            .scaleEffect(pulseScale)
        }
        .drawingGroup() // GPU acceleration
        .onAppear {
            // Animate ring fill
            withAnimation(.spring(duration: 1.2).delay(0.2)) {
                animatedProgress = progress
            }

            // Subtle pulse animation
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                pulseScale = 1.02
            }

            // Ambient glow pulse
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                ambientGlow = 0.6
            }

            isVisible = true
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
        Theme.backgroundGradient.ignoresSafeArea()

        VStack(spacing: 40) {
            StreakRingView(days: 14, hours: 6, minutes: 32, seconds: 45, progress: 0.47)

            StreakRingView(days: 0, hours: 2, minutes: 15, seconds: 30, progress: 0.1)
        }
    }
}
