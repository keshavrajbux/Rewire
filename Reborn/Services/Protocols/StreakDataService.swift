import Foundation

/// Protocol for streak data operations
/// Abstracts data layer for testability and flexibility
protocol StreakDataService: Sendable {
    /// Fetch all streaks sorted by start date (newest first)
    func fetchAll() async throws -> [Streak]

    /// Fetch the currently active streak, if any
    func fetchActive() async throws -> Streak?

    /// Save a new or updated streak
    func save(_ streak: Streak) async throws

    /// Delete a streak
    func delete(_ streak: Streak) async throws

    /// End the current streak (marks inactive with end date)
    func endCurrentStreak() async throws

    /// Start a new streak
    func startNewStreak() async throws -> Streak
}
