import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class StreakViewModel {
    // MARK: - Dependencies

    private let streakService: StreakDataService
    private let dateCalculator: DateCalculationService
    private let errorHandler: ErrorHandlingService

    // MARK: - State

    private var timer: Timer?
    private(set) var currentStreak: Streak?
    private(set) var allStreaks: [Streak] = []
    private(set) var error: AppError?
    private(set) var isLoading = false

    // Live time components
    private(set) var days: Int = 0
    private(set) var hours: Int = 0
    private(set) var minutes: Int = 0
    private(set) var seconds: Int = 0

    // MARK: - Initialization

    init(
        streakService: StreakDataService,
        dateCalculator: DateCalculationService,
        errorHandler: ErrorHandlingService
    ) {
        self.streakService = streakService
        self.dateCalculator = dateCalculator
        self.errorHandler = errorHandler
    }

    /// Convenience initializer for previews
    convenience init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Streak.self, JournalEntry.self, configurations: config)
        let context = container.mainContext
        self.init(
            streakService: SwiftDataStreakService(modelContext: context),
            dateCalculator: StreakTimeCalculator(),
            errorHandler: AppErrorHandler()
        )
    }

    // MARK: - Setup

    func setup() async {
        await fetchStreaks()
        startTimer()
    }

    // MARK: - Data Operations

    func fetchStreaks() async {
        isLoading = true
        defer { isLoading = false }

        do {
            allStreaks = try await streakService.fetchAll()
            currentStreak = try await streakService.fetchActive()

            if currentStreak == nil {
                try await startNewStreak()
            }

            updateTimeComponents()
        } catch {
            self.error = AppError.from(error)
            errorHandler.log(error, context: "StreakViewModel.fetchStreaks")
        }
    }

    func startNewStreak() async throws {
        do {
            currentStreak = try await streakService.startNewStreak()
            await fetchStreaks()
        } catch {
            self.error = AppError.from(error)
            errorHandler.log(error, context: "StreakViewModel.startNewStreak")
            throw error
        }
    }

    func resetStreak() async {
        do {
            try await streakService.endCurrentStreak()
            try await startNewStreak()
        } catch {
            self.error = AppError.from(error)
            errorHandler.log(error, context: "StreakViewModel.resetStreak")
        }
    }

    // MARK: - Computed Properties

    var longestStreak: Int {
        allStreaks.map { $0.days }.max() ?? 0
    }

    var totalCleanDays: Int {
        allStreaks.reduce(0) { $0 + $1.days }
    }

    var streakCount: Int {
        allStreaks.count
    }

    var timeComponents: TimeComponents {
        TimeComponents(days: days, hours: hours, minutes: minutes, seconds: seconds)
    }

    func formattedDuration() -> String {
        timeComponents.formattedDuration
    }

    // MARK: - Timer

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: Constants.Timer.streakUpdateInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateTimeComponents()
            }
        }
    }

    private func updateTimeComponents() {
        guard let currentStreak else {
            days = 0
            hours = 0
            minutes = 0
            seconds = 0
            return
        }

        let components = dateCalculator.components(from: currentStreak.startDate, to: Date.now)
        days = components.days
        hours = components.hours
        minutes = components.minutes
        seconds = components.seconds
    }

    // MARK: - Error Handling

    func clearError() {
        error = nil
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
