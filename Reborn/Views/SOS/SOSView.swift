import SwiftUI

struct SOSView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: SOSTab = .breathe
    @State private var pulseAnimation = false
    @State private var isContentVisible = false

    enum SOSTab: String, CaseIterable {
        case breathe = "Breathe"
        case motivation = "Motivation"
        case activities = "Activities"

        var icon: String {
            switch self {
            case .breathe: return "wind"
            case .motivation: return "heart.fill"
            case .activities: return "figure.walk"
            }
        }
    }

    var body: some View {
        ZStack {
            // Immersive pulsing gradient background
            immersiveBackground

            VStack(spacing: 0) {
                // Header
                header
                    .staggeredAppear(index: 0, isVisible: isContentVisible)

                // Tab Selector
                tabSelector
                    .staggeredAppear(index: 1, isVisible: isContentVisible)

                // Content
                TabView(selection: $selectedTab) {
                    breatheTab
                        .tag(SOSTab.breathe)

                    motivationTab
                        .tag(SOSTab.motivation)

                    activitiesTab
                        .tag(SOSTab.activities)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .onAppear {
            withAnimation(Animations.smooth.delay(0.1)) {
                isContentVisible = true
            }
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
        }
    }

    // MARK: - Immersive Background

    private var immersiveBackground: some View {
        ZStack {
            Theme.sosGradient.ignoresSafeArea()

            // Pulsing radial glow
            RadialGradient(
                colors: [
                    Theme.crimson.opacity(pulseAnimation ? 0.3 : 0.15),
                    Theme.crimson.opacity(pulseAnimation ? 0.1 : 0.05),
                    .clear
                ],
                center: .center,
                startRadius: 100,
                endRadius: 400
            )
            .ignoresSafeArea()
            .blur(radius: 50)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("YOU'VE GOT THIS")
                    .font(Theme.Typography.credits)
                    .foregroundStyle(Theme.crimson)
                    .tracking(3)

                Text("Take a moment")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.textPrimary)
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(Theme.textPrimary.opacity(0.1))
                        .frame(width: 40, height: 40)

                    Image(systemName: "xmark")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .padding()
        .padding(.top, 8)
    }

    // MARK: - Tab Selector

    private var tabSelector: some View {
        HStack(spacing: 8) {
            ForEach(SOSTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(Animations.snappy) {
                        selectedTab = tab
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: tab.icon)
                        Text(tab.rawValue)
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(selectedTab == tab ? Theme.textPrimary : Theme.textSecondary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule()
                            .fill(selectedTab == tab ? Color.white.opacity(0.15) : Color.clear)
                    )
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    // MARK: - Tabs

    private var breatheTab: some View {
        ScrollView {
            VStack(spacing: Theme.paddingXL) {
                BreathingView()
                    .padding(.top, Theme.paddingLarge)

                VStack(spacing: 12) {
                    Text("The urge to scroll will pass.")
                        .font(.headline)
                        .foregroundStyle(Theme.textPrimary)

                    Text("It always does. Usually within 15-20 minutes.")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
            }
        }
    }

    private var motivationTab: some View {
        ScrollView {
            MotivationCardsSection()
                .padding()
                .padding(.bottom, 60)
        }
    }

    private var activitiesTab: some View {
        ScrollView {
            VStack(spacing: Theme.paddingLarge) {
                VStack(spacing: 8) {
                    Text("DO SOMETHING DIFFERENT")
                        .font(Theme.Typography.credits)
                        .foregroundStyle(Theme.crimson)
                        .tracking(2)

                    Text("Replace scrolling with presence")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
                .padding(.top, Theme.paddingLarge)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(Array(Quotes.activitySuggestions.enumerated()), id: \.element.text) { index, activity in
                        ActivityCard(icon: activity.icon, text: activity.text)
                            .staggeredAppear(index: index, isVisible: isContentVisible)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 60)
            }
        }
    }
}

// MARK: - Activity Card

struct ActivityCard: View {
    let icon: String
    let text: String

    @State private var isPressed = false
    @State private var isCompleted = false

    var body: some View {
        Button {
            withAnimation(Animations.bouncy) {
                isCompleted = true
            }

            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        } label: {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? Theme.successGreen.opacity(0.2) : Theme.crimson.opacity(0.1))
                        .frame(width: 50, height: 50)

                    Image(systemName: isCompleted ? "checkmark" : icon)
                        .font(.title2)
                        .foregroundStyle(isCompleted ? Theme.successGreen : Theme.crimson)
                }

                Text(text)
                    .font(.caption)
                    .foregroundStyle(isCompleted ? Theme.successGreen : Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.paddingMedium)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(Theme.cardBlack)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(
                        isCompleted
                            ? Theme.successGreen.opacity(0.5)
                            : Theme.textPrimary.opacity(0.1),
                        lineWidth: isCompleted ? 2 : 1
                    )
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
        .disabled(isCompleted)
    }
}

#Preview {
    SOSView()
}
