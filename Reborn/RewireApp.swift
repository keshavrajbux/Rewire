import SwiftUI
import SwiftData

@main
struct RewireApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Streak.self, JournalEntry.self])
    }
}
