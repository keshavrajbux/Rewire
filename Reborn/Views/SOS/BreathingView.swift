import SwiftUI

struct BreathingView: View {
    @State private var phase: BreathingPhase = .inhale
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.3
    @State private var timer: Timer?
    @State private var countdown: Int = Constants.Breathing.inhaleSeconds
    @State private var outerRingScale: CGFloat = 1.0

    enum BreathingPhase: String {
        case inhale = "Breathe In"
        case hold = "Hold"
        case exhale = "Breathe Out"

        var duration: Int {
            switch self {
            case .inhale: return Constants.Breathing.inhaleSeconds
            case .hold: return Constants.Breathing.holdSeconds
            case .exhale: return Constants.Breathing.exhaleSeconds
            }
        }

        var next: BreathingPhase {
            switch self {
            case .inhale: return .hold
            case .hold: return .exhale
            case .exhale: return .inhale
            }
        }

        var color: Color {
            switch self {
            case .inhale: return Theme.neonBlue
            case .hold: return Theme.royalViolet
            case .exhale: return Theme.successGreen
            }
        }
    }

    var body: some View {
        VStack(spacing: 40) {
            // Title
            VStack(spacing: 8) {
                Text("4-7-8 BREATHING")
                    .font(Theme.Typography.credits)
                    .foregroundStyle(Theme.textSecondary)
                    .tracking(3)

                Text("Calm your mind")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textPrimary)
            }

            // Breathing circle
            ZStack {
                // Outer pulsing ring
                Circle()
                    .stroke(phase.color.opacity(0.2), lineWidth: 4)
                    .frame(width: 260, height: 260)
                    .scaleEffect(outerRingScale)

                // Ambient glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [phase.color.opacity(0.2), .clear],
                            center: .center,
                            startRadius: 50,
                            endRadius: 150
                        )
                    )
                    .frame(width: 300, height: 300)
                    .blur(radius: 30)

                // Main breathing circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                phase.color.opacity(opacity),
                                Theme.royalViolet.opacity(opacity * 0.5)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 125
                        )
                    )
                    .frame(width: 250, height: 250)
                    .scaleEffect(scale)
                    .shadow(color: phase.color.opacity(0.5), radius: 30)

                // Phase text and countdown
                VStack(spacing: 12) {
                    Text(phase.rawValue)
                        .font(.headline)
                        .foregroundStyle(Theme.textPrimary)
                        .textCase(.uppercase)
                        .tracking(2)

                    Text("\(countdown)")
                        .font(Theme.Typography.largeTitle)
                        .foregroundStyle(Theme.textPrimary)
                        .contentTransition(.numericText())
                        .shadow(color: phase.color.opacity(0.5), radius: 10)
                }
            }
            .drawingGroup()

            // Instruction
            Text(instructionText)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .onAppear {
            startBreathingCycle()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private var instructionText: String {
        switch phase {
        case .inhale: return "Breathe in slowly through your nose"
        case .hold: return "Hold your breath gently"
        case .exhale: return "Exhale slowly through your mouth"
        }
    }

    private func startBreathingCycle() {
        countdown = phase.duration
        animatePhase()
        startCountdown()

        // Outer ring pulse
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            outerRingScale = 1.05
        }
    }

    private func animatePhase() {
        switch phase {
        case .inhale:
            withAnimation(.easeInOut(duration: Double(phase.duration))) {
                scale = 1.0
                opacity = 0.8
            }
        case .hold:
            withAnimation(.easeInOut(duration: 0.5)) {
                opacity = 0.7
            }
        case .exhale:
            withAnimation(.easeInOut(duration: Double(phase.duration))) {
                scale = 0.5
                opacity = 0.3
            }
        }
    }

    private func startCountdown() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: Constants.Timer.breathingCountdown, repeats: true) { _ in
            Task { @MainActor in
                if countdown > 1 {
                    withAnimation(Animations.snappy) {
                        countdown -= 1
                    }
                } else {
                    phase = phase.next
                    countdown = phase.duration
                    animatePhase()

                    // Haptic on phase change
                    let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
                    impactFeedback.impactOccurred()
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Theme.sosGradient.ignoresSafeArea()
        BreathingView()
    }
}
