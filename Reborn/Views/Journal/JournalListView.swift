import SwiftUI

struct JournalListView: View {
    @Bindable var journalVM: JournalViewModel

    @State private var showCheckIn = false
    @State private var isContentVisible = false

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                if journalVM.entries.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: Theme.paddingMedium) {
                            // Hero check-in prompt
                            if !journalVM.hasCheckedInToday {
                                heroCheckInPrompt
                                    .staggeredAppear(index: 0, isVisible: isContentVisible)
                            }

                            // Journal entries
                            ForEach(Array(journalVM.entries.enumerated()), id: \.element.id) { index, entry in
                                JournalEntryCard(entry: entry)
                                    .staggeredAppear(
                                        index: journalVM.hasCheckedInToday ? index : index + 1,
                                        isVisible: isContentVisible
                                    )
                            }
                        }
                        .padding()
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    GlowingIconButton(icon: "plus", color: Theme.neonBlue, size: 36) {
                        showCheckIn = true
                    }
                }
            }
            .sheet(isPresented: $showCheckIn) {
                CheckInView(journalVM: journalVM)
            }
            .onAppear {
                withAnimation(Animations.smooth.delay(0.1)) {
                    isContentVisible = true
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: Theme.paddingLarge) {
            ZStack {
                Circle()
                    .fill(Theme.royalViolet.opacity(0.1))
                    .frame(width: 120, height: 120)

                Image(systemName: "book.closed.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(Theme.royalViolet)
            }

            VStack(spacing: 8) {
                Text("No Journal Entries Yet")
                    .font(Theme.Typography.title)
                    .foregroundStyle(.white)

                Text("Start tracking your daily well-being\nwith a quick check-in.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }

            GlowingButton(title: "First Check-In", icon: "pencil.line") {
                showCheckIn = true
            }
            .padding(.top, Theme.paddingMedium)
        }
        .scaleAndFade(isVisible: isContentVisible)
    }

    private var heroCheckInPrompt: some View {
        Button {
            showCheckIn = true
        } label: {
            HStack(spacing: Theme.paddingMedium) {
                ZStack {
                    Circle()
                        .fill(Theme.neonBlue.opacity(0.2))
                        .frame(width: 50, height: 50)

                    Image(systemName: "sun.max.fill")
                        .font(.title2)
                        .foregroundStyle(Theme.neonBlue)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Check-In")
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text("How are you feeling today?")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Theme.neonBlue)
            }
            .padding(Theme.paddingMedium)
            .cinematicCard(glowColor: Theme.neonBlue)
        }
    }
}

// MARK: - Journal Entry Card

struct JournalEntryCard: View {
    let entry: JournalEntry

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                // Mood emoji with background
                ZStack {
                    Circle()
                        .fill(moodColor.opacity(0.2))
                        .frame(width: 44, height: 44)

                    Text(entry.moodEmoji)
                        .font(.title2)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.date, style: .date)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)

                    Text(entry.date, style: .time)
                        .font(.caption2)
                        .foregroundStyle(Theme.textTertiary)
                }

                Spacer()

                // Average score badge
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(scoreColor(entry.averageScore))

                    Text(String(format: "%.1f", entry.averageScore))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(scoreColor(entry.averageScore).opacity(0.2))
                .clipShape(Capsule())
            }

            // Mini stats grid
            HStack(spacing: 0) {
                MiniStatPill(icon: "bolt.fill", value: entry.energy, label: "Energy", color: Theme.gold)
                MiniStatPill(icon: "shield.fill", value: entry.confidence, label: "Confidence", color: Theme.successGreen)
                MiniStatPill(icon: "eye.fill", value: entry.focus, label: "Focus", color: Theme.neonBlue)
                MiniStatPill(icon: "heart.fill", value: entry.mood, label: "Mood", color: Theme.royalViolet)
            }

            // Note (if exists)
            if let note = entry.note, !note.isEmpty {
                Text(note)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(isExpanded ? nil : 2)
                    .padding(.top, 4)
                    .onTapGesture {
                        withAnimation(Animations.snappy) {
                            isExpanded.toggle()
                        }
                    }
            }
        }
        .padding(Theme.paddingMedium)
        .cardStyle(elevation: .surface)
    }

    private var moodColor: Color {
        switch entry.mood {
        case 1...3: return Theme.warningRed
        case 4...5: return Theme.gold
        case 6...7: return Theme.neonBlue
        case 8...10: return Theme.successGreen
        default: return Theme.textSecondary
        }
    }

    private func scoreColor(_ score: Double) -> Color {
        switch score {
        case 1...3: return Theme.warningRed
        case 4...5: return Theme.gold
        case 6...7: return Theme.neonBlue
        case 8...10: return Theme.successGreen
        default: return Theme.textSecondary
        }
    }
}

// MARK: - Mini Stat Pill

struct MiniStatPill: View {
    let icon: String
    let value: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(color)

                Text("\(value)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }

            Text(label)
                .font(.system(size: 8))
                .foregroundStyle(Theme.textTertiary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    JournalListView(journalVM: JournalViewModel())
        .preferredColorScheme(.dark)
}
