import SwiftUI

struct JournalListView: View {
    @Bindable var journalVM: JournalViewModel

    @State private var showCheckIn = false

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                if journalVM.entries.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            // Today's check-in prompt
                            if !journalVM.hasCheckedInToday {
                                checkInPrompt
                            }

                            ForEach(journalVM.entries) { entry in
                                JournalEntryCard(entry: entry)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showCheckIn = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Theme.electricBlue)
                    }
                }
            }
            .sheet(isPresented: $showCheckIn) {
                CheckInView(journalVM: journalVM)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 50))
                .foregroundStyle(Theme.violet)

            Text("No Journal Entries Yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)

            Text("Start tracking your daily well-being\nwith a quick check-in.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)

            GlowingButton(title: "First Check-In", icon: "pencil.line") {
                showCheckIn = true
            }
            .padding(.top, 8)
        }
    }

    private var checkInPrompt: some View {
        Button {
            showCheckIn = true
        } label: {
            HStack {
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
                    .foregroundStyle(Theme.electricBlue)
            }
            .padding()
            .background(Theme.electricBlue.opacity(0.1))
            .cardStyle()
        }
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(entry.moodEmoji)
                    .font(.title2)

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

                Text(String(format: "%.1f", entry.averageScore))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(scoreColor(entry.averageScore))
            }

            // Mini stats
            HStack(spacing: 16) {
                MiniStat(icon: "bolt.fill", value: entry.energy, color: .yellow)
                MiniStat(icon: "shield.fill", value: entry.confidence, color: Theme.successGreen)
                MiniStat(icon: "eye.fill", value: entry.focus, color: Theme.electricBlue)
                MiniStat(icon: "face.smiling", value: entry.mood, color: Theme.violet)
            }

            if let note = entry.note {
                Text(note)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .cardStyle()
    }

    private func scoreColor(_ score: Double) -> Color {
        switch score {
        case 1...3: return Theme.warningRed
        case 4...5: return .orange
        case 6...7: return Theme.electricBlue
        case 8...10: return Theme.successGreen
        default: return Theme.textSecondary
        }
    }
}

struct MiniStat: View {
    let icon: String
    let value: Int
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(color)
            Text("\(value)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(Theme.textSecondary)
        }
    }
}

#Preview {
    JournalListView(journalVM: JournalViewModel())
        .preferredColorScheme(.dark)
}
