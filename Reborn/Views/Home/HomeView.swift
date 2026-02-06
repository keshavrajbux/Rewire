import SwiftUI

struct HomeView: View {
    @Bindable var streakVM: StreakViewModel
    @Bindable var milestoneVM: MilestoneViewModel
    @Bindable var journalVM: JournalViewModel

    @State private var showResetAlert = false
    @State private var showSOS = false
    @State private var dailyQuote = Quotes.randomQuote()

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    VStack(spacing: Theme.paddingLarge) {
                        // Streak Ring
                        StreakRingView(
                            days: streakVM.days,
                            hours: streakVM.hours,
                            minutes: streakVM.minutes,
                            seconds: streakVM.seconds,
                            progress: milestoneVM.progress(currentDays: streakVM.days)
                        )
                        .padding(.top, Theme.paddingLarge)

                        // Next milestone
                        if let next = milestoneVM.nextMilestone {
                            HStack {
                                Image(systemName: next.icon)
                                    .foregroundStyle(Theme.violet)
                                Text("Next: \(next.title)")
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.textSecondary)
                                if let daysLeft = milestoneVM.daysUntilNext(currentDays: streakVM.days) {
                                    Text("(\(daysLeft) days)")
                                        .font(.caption)
                                        .foregroundStyle(Theme.textTertiary)
                                }
                            }
                        }

                        // Quick Stats Row
                        HStack(spacing: 12) {
                            StatCard(title: "Longest", value: "\(streakVM.longestStreak)", unit: "days", icon: "trophy.fill")
                            StatCard(title: "Total Focus", value: "\(streakVM.totalCleanDays)", unit: "days", icon: "calendar")
                            StatCard(title: "Journal", value: "\(journalVM.entries.count)", unit: "entries", icon: "book.fill")
                        }
                        .padding(.horizontal)

                        // Daily Quote Card
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "quote.opening")
                                    .foregroundStyle(Theme.violet)
                                Text("Daily Inspiration")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Theme.textSecondary)
                            }

                            Text(dailyQuote.text)
                                .font(.body)
                                .foregroundStyle(Theme.textPrimary)
                                .italic()

                            Text("- \(dailyQuote.author)")
                                .font(.caption)
                                .foregroundStyle(Theme.textTertiary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .cardStyle()
                        .padding(.horizontal)

                        // SOS Button
                        GlowingButton(
                            title: "Emergency SOS",
                            icon: "exclamationmark.triangle.fill",
                            color: Theme.warningRed
                        ) {
                            showSOS = true
                        }

                        // Reset Button
                        Button {
                            showResetAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("I Slipped")
                            }
                            .font(.subheadline)
                            .foregroundStyle(Theme.textTertiary)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.white.opacity(0.05))
                            .clipShape(Capsule())
                        }
                        .padding(.bottom, Theme.paddingLarge)
                    }
                }
            }
            .navigationTitle("Rewire")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .alert("It's Okay", isPresented: $showResetAlert) {
                Button("Reset Streak", role: .destructive) {
                    withAnimation {
                        streakVM.resetStreak()
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Slipping doesn't erase your progress. Every day you stayed present matters. Your streak will reset, but your brain's growth is permanent.")
            }
            .fullScreenCover(isPresented: $showSOS) {
                SOSView()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Theme.electricBlue)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text(unit)
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .cardStyle()
    }
}

#Preview {
    HomeView(
        streakVM: StreakViewModel(),
        milestoneVM: MilestoneViewModel(),
        journalVM: JournalViewModel()
    )
    .preferredColorScheme(.dark)
}
