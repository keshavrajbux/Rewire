import SwiftUI

struct BreathingView: View {
    @State private var phase: BreathingPhase = .inhale
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.3
    @State private var timer: Timer?
    @State private var countdown: Int = 4

    enum BreathingPhase: String {
        case inhale = "Breathe In"
        case hold = "Hold"
        case exhale = "Breathe Out"

        var duration: Int {
            switch self {
            case .inhale: return 4
            case .hold: return 7
            case .exhale: return 8
            }
        }

        var next: BreathingPhase {
            switch self {
            case .inhale: return .hold
            case .hold: return .exhale
            case .exhale: return .inhale
            }
        }
    }

    var body: some View {
        VStack(spacing: 40) {
            Text("4-7-8 Breathing")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)

            ZStack {
                // Outer ring
                Circle()
                    .stroke(Theme.electricBlue.opacity(0.2), lineWidth: 3)
                    .frame(width: 250, height: 250)

                // Breathing circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.electricBlue.opacity(0.6), Theme.violet.opacity(0.3)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 125
                        )
                    )
                    .frame(width: 250, height: 250)
                    .scaleEffect(scale)
                    .opacity(opacity)

                // Phase text
                VStack(spacing: 8) {
                    Text(phase.rawValue)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)

                    Text("\(countdown)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                }
            }

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
    }

    private func animatePhase() {
        switch phase {
        case .inhale:
            withAnimation(.easeInOut(duration: Double(phase.duration))) {
                scale = 1.0
                opacity = 0.8
            }
        case .hold:
            withAnimation(.easeInOut(duration: 0.3)) {
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
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                if countdown > 1 {
                    withAnimation(.spring(duration: 0.3)) {
                        countdown -= 1
                    }
                } else {
                    phase = phase.next
                    countdown = phase.duration
                    animatePhase()
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
