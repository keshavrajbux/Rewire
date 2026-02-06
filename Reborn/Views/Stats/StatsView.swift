import SwiftUI
import Charts

struct StatsView: View {
    @Bindable var streakVM: StreakViewModel
    @Bindable var journalVM: JournalViewModel

    @State private var timePeriod: TimePeriod = .week

    enum TimePeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case all = "All Time"

        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .all: return 365 * 10
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    VStack(spacing: Theme.paddingLarge) {
                        // Key Metrics
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            MetricCard(title: "Current Streak", value: "\(streakVM.days)", subtitle: "days", color: Theme.electricBlue)
                            MetricCard(title: "Longest Streak", value: "\(streakVM.longestStreak)", subtitle: "days", color: Theme.violet)
                            MetricCard(title: "Total Clean", value: "\(streakVM.totalCleanDays)", subtitle: "days", color: Theme.successGreen)
                            MetricCard(title: "Avg Mood", value: String(format: "%.1f", journalVM.averageMood), subtitle: "/10", color: .yellow)
                        }
                        .padding(.horizontal)

                        // Time Period Picker
                        Picker("Period", selection: $timePeriod) {
                            ForEach(TimePeriod.allCases, id: \.self) { period in
                                Text(period.rawValue).tag(period)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)

                        // Mood Trend Chart
                        if !journalVM.entries.isEmpty {
                            moodChart
                        }

                        // Streak History
                        if streakVM.allStreaks.count > 1 {
                            streakHistoryChart
                        }

                        // Check-in Consistency
                        if !journalVM.entries.isEmpty {
                            consistencySection
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private var filteredEntries: [JournalEntry] {
        journalVM.entriesForPeriod(days: timePeriod.days)
    }

    private var moodChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mood Trend")
                .font(.headline)
                .foregroundStyle(.white)

            Chart(filteredEntries) { entry in
                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Mood", entry.mood)
                )
                .foregroundStyle(Theme.electricBlue)
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("Date", entry.date),
                    y: .value("Mood", entry.mood)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Theme.electricBlue.opacity(0.3), Theme.electricBlue.opacity(0.0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("Date", entry.date),
                    y: .value("Mood", entry.mood)
                )
                .foregroundStyle(Theme.electricBlue)
                .symbolSize(30)
            }
            .chartYScale(domain: 1...10)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel()
                        .foregroundStyle(Theme.textTertiary)
                    AxisGridLine()
                        .foregroundStyle(Color.white.opacity(0.1))
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .frame(height: 200)
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }

    private var streakHistoryChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Streak History")
                .font(.headline)
                .foregroundStyle(.white)

            Chart(streakVM.allStreaks) { streak in
                BarMark(
                    x: .value("Start", streak.startDate),
                    y: .value("Days", streak.days)
                )
                .foregroundStyle(
                    streak.isActive ? Theme.electricBlue : Theme.violet.opacity(0.6)
                )
                .cornerRadius(4)
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisValueLabel()
                        .foregroundStyle(Theme.textTertiary)
                    AxisGridLine()
                        .foregroundStyle(Color.white.opacity(0.1))
                }
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .frame(height: 180)
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }

    private var consistencySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Check-in Consistency")
                .font(.headline)
                .foregroundStyle(.white)

            let weekEntries = journalVM.entriesForPeriod(days: 7)
            let consistency = min(Double(weekEntries.count) / 7.0, 1.0)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(weekEntries.count)/7")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("this week")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }

                Spacer()

                CircularProgressView(progress: consistency, color: Theme.successGreen)
                    .frame(width: 60, height: 60)
            }

            // Metric breakdown
            if let latest = filteredEntries.first {
                HStack(spacing: 20) {
                    MetricBreakdown(label: "Energy", value: latest.energy, color: .yellow)
                    MetricBreakdown(label: "Confidence", value: latest.confidence, color: Theme.successGreen)
                    MetricBreakdown(label: "Focus", value: latest.focus, color: Theme.electricBlue)
                    MetricBreakdown(label: "Mood", value: latest.mood, color: Theme.violet)
                }
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cardStyle()
    }
}

struct CircularProgressView: View {
    let progress: Double
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 6)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))

            Text("\(Int(progress * 100))%")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
    }
}

struct MetricBreakdown: View {
    let label: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StatsView(streakVM: StreakViewModel(), journalVM: JournalViewModel())
        .preferredColorScheme(.dark)
}
