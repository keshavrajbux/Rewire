import Foundation

/// Protocol for journal entry data operations
/// Abstracts data layer for testability and flexibility
protocol JournalDataService: Sendable {
    /// Fetch all journal entries sorted by date (newest first)
    func fetchAll() async throws -> [JournalEntry]

    /// Fetch entries for a specific number of past days
    func entriesForPeriod(days: Int) async throws -> [JournalEntry]

    /// Check if user has checked in today
    func hasCheckedInToday() async throws -> Bool

    /// Save a new journal entry
    func save(_ entry: JournalEntry) async throws

    /// Delete a journal entry
    func delete(_ entry: JournalEntry) async throws

    /// Create and save a new entry with the given values
    func createEntry(
        energy: Int,
        confidence: Int,
        focus: Int,
        mood: Int,
        note: String?
    ) async throws -> JournalEntry
}
