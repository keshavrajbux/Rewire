import SwiftUI

/// Cinematic hero section with parallax effect and dramatic styling
struct HeroSection<Content: View>: View {
    let title: String
    let subtitle: String?
    let gradient: LinearGradient
    let scrollOffset: CGFloat
    @ViewBuilder let content: () -> Content

    @State private var isVisible = false

    init(
        title: String,
        subtitle: String? = nil,
        gradient: LinearGradient = Theme.primaryGradient,
        scrollOffset: CGFloat = 0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.gradient = gradient
        self.scrollOffset = scrollOffset
        self.content = content
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background gradient with parallax
            Rectangle()
                .fill(gradient)
                .frame(height: 280)
                .offset(y: -scrollOffset * 0.3)
                .overlay(
                    // Vignette overlay
                    LinearGradient(
                        colors: [
                            .clear,
                            Theme.deepBlack.opacity(0.3),
                            Theme.deepBlack
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .ignoresSafeArea()

            // Content container
            VStack(spacing: Theme.paddingMedium) {
                // Title with gradient text
                Text(title)
                    .font(Theme.Typography.largeTitle)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 20)

                if let subtitle {
                    Text(subtitle)
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .textCase(.uppercase)
                        .tracking(2)
                        .opacity(isVisible ? 1 : 0)
                        .offset(y: isVisible ? 0 : 10)
                }

                content()
                    .opacity(isVisible ? 1 : 0)
                    .scaleEffect(isVisible ? 1 : 0.95)
            }
            .padding(.horizontal, Theme.paddingLarge)
            .padding(.bottom, Theme.paddingXL)
        }
        .onAppear {
            withAnimation(Animations.smooth.delay(0.1)) {
                isVisible = true
            }
        }
    }
}

/// Compact hero section for smaller displays
struct CompactHeroSection: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color

    @State private var isVisible = false

    var body: some View {
        HStack(spacing: Theme.paddingMedium) {
            // Icon with glow
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .textCase(.uppercase)
                    .tracking(1)

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(Theme.Typography.title)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())

                    Text(unit)
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.textTertiary)
                }
            }

            Spacer()
        }
        .padding(Theme.paddingMedium)
        .cinematicCard(glowColor: color)
        .opacity(isVisible ? 1 : 0)
        .offset(x: isVisible ? 0 : -20)
        .onAppear {
            withAnimation(Animations.smooth) {
                isVisible = true
            }
        }
    }
}

/// Large hero metric display
struct HeroMetric: View {
    let value: String
    let label: String
    let color: Color

    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(Theme.Typography.heroDisplay)
                .foregroundStyle(
                    LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: color.opacity(0.5), radius: 20)
                .contentTransition(.numericText())

            Text(label)
                .font(Theme.Typography.credits)
                .foregroundStyle(Theme.textSecondary)
                .textCase(.uppercase)
                .tracking(4)
        }
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(Animations.dramatic) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        ScrollView {
            VStack(spacing: 20) {
                HeroSection(
                    title: "14",
                    subtitle: "Days Strong",
                    gradient: Theme.primaryGradient,
                    scrollOffset: 0
                ) {
                    Text("Keep going!")
                        .foregroundStyle(.white)
                }

                CompactHeroSection(
                    title: "Current Streak",
                    value: "14",
                    unit: "days",
                    icon: "flame.fill",
                    color: Theme.neonBlue
                )
                .padding(.horizontal)

                HeroMetric(
                    value: "30",
                    label: "Days",
                    color: Theme.neonBlue
                )
            }
        }
    }
}
