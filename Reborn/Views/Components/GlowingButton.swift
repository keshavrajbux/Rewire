import SwiftUI

struct GlowingButton: View {
    let title: String
    let icon: String?
    let color: Color
    let action: () -> Void

    @State private var isGlowing = false
    @State private var isPressed = false
    @State private var shimmerOffset: CGFloat = -200

    init(title: String, icon: String? = nil, color: Color = Theme.electricBlue, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }

    var body: some View {
        Button {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred(intensity: Constants.Haptics.buttonImpactIntensity)

            action()
        } label: {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.headline)
                }
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 16)
            .background(
                ZStack {
                    // Base gradient
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    // Shimmer sweep
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .white.opacity(0.3), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: shimmerOffset)
                        .mask(Capsule())
                }
            )
            .overlay(
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.4), color.opacity(0.2)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
            // Multi-layer glow shadows
            .shadow(color: color.opacity(0.3), radius: 4, y: 2)
            .shadow(color: color.opacity(isGlowing ? 0.6 : 0.3), radius: isGlowing ? 25 : 12)
            .shadow(color: color.opacity(isGlowing ? 0.3 : 0.1), radius: isGlowing ? 40 : 20)
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(Animations.snappy) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(Animations.snappy) {
                        isPressed = false
                    }
                }
        )
        .onAppear {
            // Pulsing glow animation
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isGlowing = true
            }

            // Shimmer animation
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                shimmerOffset = 200
            }
        }
    }
}

/// Compact button variant for inline use
struct CompactGlowButton: View {
    let title: String
    let icon: String?
    let color: Color
    let action: () -> Void

    @State private var isPressed = false

    init(title: String, icon: String? = nil, color: Color = Theme.electricBlue, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }

    var body: some View {
        Button {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        } label: {
            HStack(spacing: 6) {
                if let icon {
                    Image(systemName: icon)
                        .font(.subheadline)
                }
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(color.opacity(0.2))
            )
            .overlay(
                Capsule()
                    .stroke(color.opacity(0.4), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(Animations.snappy) { isPressed = true }
                }
                .onEnded { _ in
                    withAnimation(Animations.snappy) { isPressed = false }
                }
        )
    }
}

/// Icon-only glowing button
struct GlowingIconButton: View {
    let icon: String
    let color: Color
    let size: CGFloat
    let action: () -> Void

    @State private var isGlowing = false
    @State private var isPressed = false

    init(
        icon: String,
        color: Color = Theme.electricBlue,
        size: CGFloat = 50,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.color = color
        self.size = size
        self.action = action
    }

    var body: some View {
        Button {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            action()
        } label: {
            Image(systemName: icon)
                .font(.system(size: size * 0.4))
                .foregroundStyle(.white)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: color.opacity(isGlowing ? 0.6 : 0.3), radius: isGlowing ? 15 : 8)
                .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(Animations.snappy) { isPressed = true }
                }
                .onEnded { _ in
                    withAnimation(Animations.snappy) { isPressed = false }
                }
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isGlowing = true
            }
        }
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        VStack(spacing: 20) {
            GlowingButton(title: "Start Journey", icon: "play.fill") {}

            GlowingButton(title: "Emergency SOS", icon: "exclamationmark.triangle.fill", color: Theme.warningRed) {}

            HStack(spacing: 16) {
                CompactGlowButton(title: "Quick Action", icon: "bolt.fill") {}
                CompactGlowButton(title: "Settings", icon: "gear", color: Theme.royalViolet) {}
            }

            HStack(spacing: 20) {
                GlowingIconButton(icon: "plus", color: Theme.successGreen) {}
                GlowingIconButton(icon: "heart.fill", color: Theme.crimson) {}
                GlowingIconButton(icon: "star.fill", color: Theme.gold) {}
            }
        }
    }
}
