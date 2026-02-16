import SwiftUI
import SwiftData

@main
struct RewireApp: App {
    private let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: Streak.self, JournalEntry.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            AppContainerView()
                .modelContainer(modelContainer)
        }
    }
}

/// Root view that initializes the dependency container
struct AppContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var container: AppContainer?

    var body: some View {
        Group {
            if let container {
                ContentView()
                    .environment(\.appContainer, container)
            } else {
                // Loading state while container initializes
                ZStack {
                    Theme.backgroundGradient.ignoresSafeArea()
                    ProgressView()
                        .tint(Theme.neonBlue)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            if container == nil {
                container = AppContainer(modelContext: modelContext)
            }
        }
    }
}

#Preview {
    AppContainerView()
        .modelContainer(for: [Streak.self, JournalEntry.self])
}
