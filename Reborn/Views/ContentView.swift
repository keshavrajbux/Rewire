import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var streakVM = StreakViewModel()
    @State private var journalVM = JournalViewModel()
    @State private var milestoneVM = MilestoneViewModel()
    @State private var selectedTab: Tab = .home

    enum Tab: String {
        case home = "Home"
        case journal = "Journal"
        case milestones = "Milestones"
        case stats = "Stats"
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(streakVM: streakVM, milestoneVM: milestoneVM, journalVM: journalVM)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)

            JournalListView(journalVM: journalVM)
                .tabItem {
                    Label("Journal", systemImage: "book.fill")
                }
                .tag(Tab.journal)

            MilestonesView(milestoneVM: milestoneVM, currentDays: streakVM.days)
                .tabItem {
                    Label("Milestones", systemImage: "trophy.fill")
                }
                .tag(Tab.milestones)

            StatsView(streakVM: streakVM, journalVM: journalVM)
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(Tab.stats)
        }
        .tint(Theme.electricBlue)
        .preferredColorScheme(.dark)
        .onAppear {
            setupViewModels()
            configureTabBarAppearance()
        }
        .onChange(of: streakVM.days) { _, newValue in
            milestoneVM.updateMilestones(currentStreakDays: newValue)
        }
    }

    private func setupViewModels() {
        streakVM.setup(modelContext: modelContext)
        journalVM.setup(modelContext: modelContext)
        milestoneVM.updateMilestones(currentStreakDays: streakVM.days)
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Theme.darkBackground)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Streak.self, JournalEntry.self])
}
