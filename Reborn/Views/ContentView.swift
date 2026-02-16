import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.appContainer) private var container
    @Environment(\.modelContext) private var modelContext

    @State private var streakVM: StreakViewModel?
    @State private var journalVM: JournalViewModel?
    @State private var milestoneVM = MilestoneViewModel()
    @State private var selectedTab: Tab = .home
    @Namespace private var tabNamespace

    enum Tab: String, CaseIterable {
        case home = "Home"
        case journal = "Journal"
        case milestones = "Milestones"
        case stats = "Stats"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .journal: return "book.fill"
            case .milestones: return "trophy.fill"
            case .stats: return "chart.bar.fill"
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            Group {
                if let streakVM, let journalVM {
                    TabView(selection: $selectedTab) {
                        HomeView(streakVM: streakVM, milestoneVM: milestoneVM, journalVM: journalVM)
                            .tag(Tab.home)

                        JournalListView(journalVM: journalVM)
                            .tag(Tab.journal)

                        MilestonesView(milestoneVM: milestoneVM, currentDays: streakVM.days)
                            .tag(Tab.milestones)

                        StatsView(streakVM: streakVM, journalVM: journalVM)
                            .tag(Tab.stats)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                } else {
                    // Loading state
                    ZStack {
                        Theme.backgroundGradient.ignoresSafeArea()
                        ProgressView()
                            .tint(Theme.neonBlue)
                    }
                }
            }
            .padding(.bottom, Constants.Layout.tabBarHeight)

            // Custom floating tab bar
            customTabBar
        }
        .ignoresSafeArea(.keyboard)
        .preferredColorScheme(.light)
        .task {
            await setupViewModels()
        }
        .onChange(of: streakVM?.days ?? 0) { _, newValue in
            milestoneVM.updateMilestones(currentStreakDays: newValue)
        }
    }

    // MARK: - Custom Tab Bar

    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, Theme.paddingMedium)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
        )
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.15), .white.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
        .padding(.horizontal, Theme.paddingLarge)
        .padding(.bottom, Constants.Layout.tabBarBottomPadding)
    }

    private func tabButton(for tab: Tab) -> some View {
        Button {
            withAnimation(Animations.snappy) {
                selectedTab = tab
            }
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(selectedTab == tab ? Theme.neonBlue : Theme.textTertiary)
                    .frame(width: 50, height: 32)
                    .background {
                        if selectedTab == tab {
                            Capsule()
                                .fill(Theme.neonBlue.opacity(0.2))
                                .matchedGeometryEffect(id: "tabIndicator", in: tabNamespace)
                        }
                    }

                Text(tab.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(selectedTab == tab ? Theme.neonBlue : Theme.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Setup

    private func setupViewModels() async {
        guard let container else { return }

        let streak = StreakViewModel(
            streakService: container.streakService,
            dateCalculator: container.dateCalculator,
            errorHandler: container.errorHandler
        )
        let journal = JournalViewModel(
            journalService: container.journalService,
            errorHandler: container.errorHandler
        )

        await streak.setup()
        await journal.setup()

        streakVM = streak
        journalVM = journal

        milestoneVM.updateMilestones(currentStreakDays: streak.days)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Streak.self, JournalEntry.self])
        .environment(\.appContainer, AppContainer.preview())
}
