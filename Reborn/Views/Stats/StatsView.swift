import SwiftUI
import Charts

struct StatsView: View {
    @Bindable var streakVM: StreakViewModel
    @Bindable var journalVM: JournalViewModel

    @State private var timePeriod: TimePeriod = .week
    @State private var isContentVisible = false

    enum TimePeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case all = "All Time"

        var days: Int {
            switch self {
            case .week: return Constants.TimePeriod.week
            case .month: return Constants.TimePeriod.month
            case .all: return Constants.TimePeriod.allTime
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    LazyVStack(spacing: Theme.paddingLarge) {
                        // Hero Metrics Grid
                        heroMetrics
                            .staggeredAppear(index: 0, isVisible: isContentVisible)

                        // Time Period Picker
                        periodPicker
                            .staggeredAppear(index: 1, isVisible: isContentVisible)

                        // Mood Trend Chart
                        if !journalVM.entries.isEmpty {
                            moodChart
                                .staggeredAppear(index: 2, isVisible: isContentVisible)
                        }

                        // Streak History
                        if streakVM.allStreaks.count > 1 {
                            streakHistoryChart
                                .staggeredAppear(index: 3, isVisible: isContentVisible)
                        }

                        // Check-in Consistency
                        if !journalVM.entries.isEmpty {
                            consistencySection
                                .staggeredAppear(index: 4, isVisible: isContentVisible)
                        }

                        Spacer(minLength: 120)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear {
                withAnimation(Animations.smooth.delay(0.1)) {
                    isContentVisible = true
                }
            }
        }
    }

    // MARK: - Hero Metrics

    private var heroMetrics: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            HeroMetricCard(
                title: "Current Streak",
                value: "\(streakVM.days)",
                subtitle: "days",
                icon: "flame.fill",
                color: Theme.neonBlue
            )
            HeroMetricCard(
                title: "Longest Streak",
                value: "\(streakVM.longestStreak)",
                subtitle: "days",
                icon: "trophy.fill",
                color: Theme.gold
            )
            HeroMetricCard(
                title: "Total Clean",
                value: "\(streakVM.totalCleanDays)",
                subtitle: "days",
                icon: "calendar",
                color: Theme.successGreen
            )
            HeroMetricCard(
                title: "Avg Mood",
                value: String(format: "%.1f", journalVM.averageMood),
                subtitle: "/10",
                icon: "heart.fill",
                color: Theme.royalViolet
            )
        }
        .padding(.horizontal)
    }

    private var periodPicker: some View {
        Picker("Period", selection: $timePeriod) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }

    private var filteredEntries: [JournalEntry] {
        journalVM.entriesForPeriod(days: timePeriod.days)
    }

    // MARK: - Mood Chart

    private var moodChart: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            HStack {
                Text("Mood Trend")
                    .font(.headline)
                    .foregroundStyle(.white)

                Spacer()

                if let latest = filteredEntries.first {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Theme.neonBlue)
                            .frame(width: 8, height: 8)
                        Text("Latest: \(latest.mood)/10")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }

            Chart(filteredEntries) { entry in
                // Area fill
                AreaMark(
                    x: .value("Date", entry.date),
                    y: .value("Mood", entry.mood)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Theme.neonBlue.opacity(0.4), Theme.neonBlue.opacity(0.0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)

                // Line
                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Mood", entry.mood)
                )
                .foregroundStyle(Theme.neonBlue)
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 2))

                // Points
                PointMark(
                    x: .value("Date", entry.date),
                    y: .value("Mood", entry.mood)
                )
                .foregroundStyle(Theme.neonBlue)
                .symbolSize(40)
            }
            .chartYScale(domain: 1...10)
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
            .frame(height: 200)
        }
        .padding(Theme.paddingMedium)
        .cinematicCard(glowColor: Theme.neonBlue)
        .padding(.horizontal)
    }

    // MARK: - Streak History

    private var streakHistoryChart: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            Text("Streak History")
                .font(.headline)
                .foregroundStyle(.white)

            Chart(streakVM.allStreaks) { streak in
                BarMark(
                    x: .value("Start", streak.startDate),
                    y: .value("Days", streak.days)
                )
                .foregroundStyle(
                    streak.isActive
                        ? LinearGradient(
                            colors: [Theme.neonBlue, Theme.royalViolet],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        : LinearGradient(
                            colors: [Theme.royalViolet.opacity(0.5), Theme.royalViolet.opacity(0.3)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
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
        .padding(Theme.paddingMedium)
        .cinematicCard(glowColor: Theme.royalViolet)
        .padding(.horizontal)
    }

    // MARK: - Consistency Section

    private var consistencySection: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            Text("Check-in Consistency")
                .font(.headline)
                .foregroundStyle(.white)

            let weekEntries = journalVM.entriesForPeriod(days: 7)
            let consistency = min(Double(weekEntries.count) / 7.0, 1.0)

            HStack(spacing: Theme.paddingLarge) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(weekEntries.count)/7")
                        .font(Theme.Typography.title)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())

                    Text("this week")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }

                Spacer()

                // Animated progress ring
                ZStack {
                    Circle()
                        .stroke(Theme.successGreen.opacity(0.2), lineWidth: 8)
                        .frame(width: 70, height: 70)

                    Circle()
                        .trim(from: 0, to: consistency)
                        .stroke(Theme.successGreen, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 70, height: 70)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: Theme.successGreen.opacity(0.5), radius: 6)

                    Text("\(Int(consistency * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.successGreen)
                }
            }

            // Latest metrics breakdown
            if let latest = filteredEntries.first {
                Divider()
                    .background(Color.white.opacity(0.1))

                HStack(spacing: 0) {
                    MetricBreakdownItem(label: "Energy", value: latest.energy, color: Theme.gold)
                    MetricBreakdownItem(label: "Confidence", value: latest.confidence, color: Theme.successGreen)
                    MetricBreakdownItem(label: "Focus", value: latest.focus, color: Theme.neonBlue)
                    MetricBreakdownItem(label: "Mood", value: latest.mood, color: Theme.royalViolet)
                }
            }
        }
        .padding(Theme.paddingMedium)
        .cinematicCard(glowColor: Theme.successGreen)
        .padding(.horizontal)
    }
}

// MARK: - Hero Metric Card

struct HeroMetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
                Spacer()
            }

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Theme.paddingMedium)
        .background(color.opacity(0.1))
        .cardStyle()
    }
}

// MARK: - Metric Breakdown Item

struct MetricBreakdownItem: View {
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
                .font(.system(size: 9))
                .foregroundStyle(Theme.textTertiary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StatsView(streakVM: StreakViewModel(), journalVM: JournalViewModel())
        .preferredColorScheme(.dark)
}
