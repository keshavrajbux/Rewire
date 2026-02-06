import SwiftUI

struct SOSView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: SOSTab = .breathe
    @State private var pulseAnimation = false

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
            Theme.sosGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("You've Got This")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .padding()

                // Tab Selector
                HStack(spacing: 4) {
                    ForEach(SOSTab.allCases, id: \.self) { tab in
                        Button {
                            withAnimation(.spring(duration: 0.3)) {
                                selectedTab = tab
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: tab.icon)
                                Text(tab.rawValue)
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(selectedTab == tab ? .white : Theme.textSecondary)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(
                                selectedTab == tab
                                    ? Capsule().fill(Color.white.opacity(0.15))
                                    : Capsule().fill(Color.clear)
                            )
                        }
                    }
                }
                .padding(.horizontal)

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
    }

    private var breatheTab: some View {
        ScrollView {
            VStack(spacing: 30) {
                BreathingView()
                    .padding(.top, 20)

                Text("The urge to scroll will pass. It always does.\nUsually within 15-20 minutes.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
            }
        }
    }

    private var motivationTab: some View {
        ScrollView {
            MotivationCardsSection()
                .padding()
        }
    }

    private var activitiesTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Do Something Different")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.top, 20)

                Text("Replace scrolling with presence")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(Quotes.activitySuggestions, id: \.text) { activity in
                        ActivityCard(icon: activity.icon, text: activity.text)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
    }
}

struct ActivityCard: View {
    let icon: String
    let text: String

    @State private var isPressed = false

    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.2)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { isPressed = false }
            }
        } label: {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(isPressed ? Theme.successGreen : Theme.electricBlue)

                Text(text)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .cardStyle()
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(isPressed ? Theme.successGreen.opacity(0.5) : Color.clear, lineWidth: 2)
            )
        }
    }
}

#Preview {
    SOSView()
}
