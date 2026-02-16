import SwiftUI

struct HomeView: View {
    @Bindable var streakVM: StreakViewModel
    @Bindable var milestoneVM: MilestoneViewModel
    @Bindable var journalVM: JournalViewModel

    @State private var showResetAlert = false
    @State private var showSOS = false
    @State private var dailyQuote = Quotes.randomQuote()
    @State private var scrollOffset: CGFloat = 0
    @State private var isContentVisible = false

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    LazyVStack(spacing: Theme.paddingLarge) {
                        // Hero Streak Ring with parallax
                        StreakRingView(
                            days: streakVM.days,
                            hours: streakVM.hours,
                            minutes: streakVM.minutes,
                            seconds: streakVM.seconds,
                            progress: milestoneVM.progress(currentDays: streakVM.days)
                        )
                        .padding(.top, Theme.paddingXL)
                        .staggeredAppear(index: 0, isVisible: isContentVisible)

                        // Next milestone indicator
                        if let next = milestoneVM.nextMilestone {
                            nextMilestoneCard(next)
                                .staggeredAppear(index: 1, isVisible: isContentVisible)
                        }

                        // Quick Stats Carousel
                        QuickStatsCarousel(stats: [
                            .init(
                                title: "Longest",
                                value: "\(streakVM.longestStreak)",
                                unit: "days",
                                icon: "trophy.fill",
                                color: Theme.gold
                            ),
                            .init(
                                title: "Total Focus",
                                value: "\(streakVM.totalCleanDays)",
                                unit: "days",
                                icon: "calendar",
                                color: Theme.successGreen
                            ),
                            .init(
                                title: "Journal",
                                value: "\(journalVM.entries.count)",
                                unit: "entries",
                                icon: "book.fill",
                                color: Theme.royalViolet
                            ),
                            .init(
                                title: "Avg Mood",
                                value: String(format: "%.1f", journalVM.averageMood),
                                unit: "/10",
                                icon: "face.smiling",
                                color: Theme.neonBlue
                            )
                        ])
                        .staggeredAppear(index: 2, isVisible: isContentVisible)

                        // Cinematic Quote Card
                        quoteCard
                            .padding(.horizontal, Theme.paddingLarge)
                            .staggeredAppear(index: 3, isVisible: isContentVisible)

                        // SOS Button
                        GlowingButton(
                            title: "Emergency SOS",
                            icon: "exclamationmark.triangle.fill",
                            color: Theme.warningRed
                        ) {
                            showSOS = true
                        }
                        .staggeredAppear(index: 4, isVisible: isContentVisible)

                        // Reset Button
                        resetButton
                            .staggeredAppear(index: 5, isVisible: isContentVisible)

                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Rewire")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .alert("It's Okay", isPresented: $showResetAlert) {
                Button("Reset Streak", role: .destructive) {
                    Task {
                        await streakVM.resetStreak()
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Slipping doesn't erase your progress. Every day you stayed present matters. Your streak will reset, but your brain's growth is permanent.")
            }
            .fullScreenCover(isPresented: $showSOS) {
                SOSView()
            }
            .onAppear {
                withAnimation(Animations.smooth.delay(0.1)) {
                    isContentVisible = true
                }
            }
        }
    }

    // MARK: - Components

    private func nextMilestoneCard(_ milestone: Milestone) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Theme.royalViolet.opacity(0.2))
                    .frame(width: 44, height: 44)

                Image(systemName: milestone.icon)
                    .font(.title3)
                    .foregroundStyle(Theme.royalViolet)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Next: \(milestone.title)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Theme.textPrimary)

                if let daysLeft = milestoneVM.daysUntilNext(currentDays: streakVM.days) {
                    Text("\(daysLeft) days to go")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }
            }

            Spacer()

            // Progress ring
            ZStack {
                Circle()
                    .stroke(Theme.royalViolet.opacity(0.2), lineWidth: 3)
                    .frame(width: 40, height: 40)

                Circle()
                    .trim(from: 0, to: milestoneVM.progress(currentDays: streakVM.days))
                    .stroke(Theme.royalViolet, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(-90))
            }
        }
        .padding(Theme.paddingMedium)
        .cardStyle(elevation: .raised)
        .padding(.horizontal, Theme.paddingLarge)
    }

    private var quoteCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.title2)
                    .foregroundStyle(Theme.royalViolet)

                Spacer()

                Text("Daily Inspiration")
                    .font(Theme.Typography.credits)
                    .foregroundStyle(Theme.textTertiary)
                    .textCase(.uppercase)
                    .tracking(2)
            }

            Text(dailyQuote.text)
                .font(.body)
                .foregroundStyle(Theme.textPrimary)
                .italic()
                .lineSpacing(4)

            HStack {
                Spacer()
                Text("— \(dailyQuote.author)")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .padding(Theme.paddingLarge)
        .cinematicCard(glowColor: Theme.royalViolet)
    }

    private var resetButton: some View {
        Button {
            showResetAlert = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.counterclockwise")
                Text("I Slipped")
            }
            .font(.subheadline)
            .foregroundStyle(Theme.textTertiary)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                Capsule()
                    .fill(Theme.textPrimary.opacity(0.05))
            )
            .overlay(
                Capsule()
                    .stroke(Theme.textPrimary.opacity(0.1), lineWidth: 1)
            )
        }
        .padding(.bottom, Theme.paddingLarge)
    }
}

#Preview {
    HomeView(
        streakVM: StreakViewModel(),
        milestoneVM: MilestoneViewModel(),
        journalVM: JournalViewModel()
    )
    .preferredColorScheme(.light)
}
