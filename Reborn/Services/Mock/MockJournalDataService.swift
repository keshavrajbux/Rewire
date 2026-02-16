import Foundation

/// Mock implementation of JournalDataService for testing and previews
final class MockJournalDataService: JournalDataService, @unchecked Sendable {
    private var entries: [JournalEntry] = []

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
        let calendar = Calendar.current
        let now = Date.now

        // Create sample entries for the past week
        for i in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: now) else { continue }

            let entry = JournalEntry(
                date: date,
                energy: Int.random(in: 4...9),
                confidence: Int.random(in: 5...8),
                focus: Int.random(in: 4...9),
                mood: Int.random(in: 5...9),
                note: i == 0 ? "Feeling good today, stayed focused!" : nil
            )
            entries.append(entry)
        }
    }

    func fetchAll() async throws -> [JournalEntry] {
        if fetchDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(fetchDelay * 1_000_000_000))
        }
        if shouldThrowOnFetch {
            throw AppError.dataFetchFailure("Mock fetch error")
        }
        return entries.sorted { $0.date > $1.date }
    }

    func entriesForPeriod(days: Int) async throws -> [JournalEntry] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: .now) ?? .now
        return try await fetchAll().filter { $0.date >= cutoff }
    }

    func hasCheckedInToday() async throws -> Bool {
        guard let latest = entries.max(by: { $0.date < $1.date }) else {
            return false
        }
        return Calendar.current.isDateInToday(latest.date)
    }

    func save(_ entry: JournalEntry) async throws {
        if shouldThrowOnSave {
            throw AppError.dataSaveFailure("Mock save error")
        }
        if !entries.contains(where: { $0.id == entry.id }) {
            entries.append(entry)
        }
    }

    func delete(_ entry: JournalEntry) async throws {
        entries.removeAll { $0.id == entry.id }
    }

    func createEntry(
        energy: Int,
        confidence: Int,
        focus: Int,
        mood: Int,
        note: String?
    ) async throws -> JournalEntry {
        if shouldThrowOnSave {
            throw AppError.dataSaveFailure("Mock save error")
        }

        // Validate input
        guard (1...10).contains(energy) else {
            throw AppError.validationFailed("Energy must be between 1 and 10")
        }
        guard (1...10).contains(confidence) else {
            throw AppError.validationFailed("Confidence must be between 1 and 10")
        }
        guard (1...10).contains(focus) else {
            throw AppError.validationFailed("Focus must be between 1 and 10")
        }
        guard (1...10).contains(mood) else {
            throw AppError.validationFailed("Mood must be between 1 and 10")
        }

        let entry = JournalEntry(
            energy: energy,
            confidence: confidence,
            focus: focus,
            mood: mood,
            note: note?.isEmpty == true ? nil : note
        )
        entries.append(entry)
        return entry
    }
}
