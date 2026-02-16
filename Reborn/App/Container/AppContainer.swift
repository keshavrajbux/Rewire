import Foundation
import SwiftData
import SwiftUI

/// Dependency Injection container for the Reborn app
/// Provides all services needed throughout the application
@MainActor
final class AppContainer: ObservableObject {
    // MARK: - Services

    let streakService: StreakDataService
    let journalService: JournalDataService
    let dateCalculator: DateCalculationService
    let errorHandler: ErrorHandlingService

    // MARK: - Initialization

    init(modelContext: ModelContext) {
        self.streakService = SwiftDataStreakService(modelContext: modelContext)
        self.journalService = SwiftDataJournalService(modelContext: modelContext)
        self.dateCalculator = StreakTimeCalculator()
        self.errorHandler = AppErrorHandler()
    }

    /// Creates a container with mock services for previews and testing
    static func preview() -> AppContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Streak.self, JournalEntry.self, configurations: config)
        return AppContainer(modelContext: container.mainContext)
    }
}

/// Environment key for accessing the container
struct AppContainerKey: EnvironmentKey {
    @MainActor
    static let defaultValue: AppContainer? = nil
}

extension EnvironmentValues {
    var appContainer: AppContainer? {
        get { self[AppContainerKey.self] }
        set { self[AppContainerKey.self] = newValue }
    }
}

extension View {
    func appContainer(_ container: AppContainer) -> some View {
        environment(\.appContainer, container)
    }
}
