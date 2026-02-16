import Foundation

/// Mock implementation of StreakDataService for testing and previews
final class MockStreakDataService: StreakDataService, @unchecked Sendable {
    private var streaks: [Streak] = []
    private var activeStreak: Streak?

    // Control flags for testing
    var shouldThrowOnFetch = false
    var shouldThrowOnSave = false
    var fetchDelay: TimeInterval = 0

    init(withSampleData: Bool = false) {
        if withSampleData {
            setupSampleData()
        }
    }

    private func setupSampleData() {
        // Create some sample streaks for testing
        let now = Date.now
        let calendar = Calendar.current

        // Active streak - 14 days
        let activeStart = calendar.date(byAdding: .day, value: -14, to: now)!
        let active = Streak(startDate: activeStart)
        activeStreak = active
        streaks.append(active)

        // Past streak - 7 days
        let pastEnd = calendar.date(byAdding: .day, value: -20, to: now)!
        let pastStart = calendar.date(byAdding: .day, value: -27, to: now)!
        let past = Streak(startDate: pastStart, endDate: pastEnd, isActive: false)
        streaks.append(past)

        // Another past streak - 3 days
        let past2End = calendar.date(byAdding: .day, value: -35, to: now)!
        let past2Start = calendar.date(byAdding: .day, value: -38, to: now)!
        let past2 = Streak(startDate: past2Start, endDate: past2End, isActive: false)
        streaks.append(past2)
    }

    func fetchAll() async throws -> [Streak] {
        if fetchDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(fetchDelay * 1_000_000_000))
        }
        if shouldThrowOnFetch {
            throw AppError.dataFetchFailure("Mock fetch error")
        }
        return streaks.sorted { $0.startDate > $1.startDate }
    }

    func fetchActive() async throws -> Streak? {
        if shouldThrowOnFetch {
            throw AppError.dataFetchFailure("Mock fetch error")
        }
        return activeStreak
    }

    func save(_ streak: Streak) async throws {
        if shouldThrowOnSave {
            throw AppError.dataSaveFailure("Mock save error")
        }
        if !streaks.contains(where: { $0.id == streak.id }) {
            streaks.append(streak)
        }
    }

    func delete(_ streak: Streak) async throws {
        streaks.removeAll { $0.id == streak.id }
        if activeStreak?.id == streak.id {
            activeStreak = nil
        }
    }

    func endCurrentStreak() async throws {
        guard let current = activeStreak else {
            throw AppError.streakNotFound
        }
        current.isActive = false
        current.endDate = Date.now
        activeStreak = nil
    }

    func startNewStreak() async throws -> Streak {
        if shouldThrowOnSave {
            throw AppError.dataSaveFailure("Mock save error")
        }
        let newStreak = Streak()
        streaks.append(newStreak)
        activeStreak = newStreak
        return newStreak
    }
}
