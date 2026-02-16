import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class JournalViewModel {
    // MARK: - Dependencies

    private let journalService: JournalDataService
    private let errorHandler: ErrorHandlingService

    // MARK: - State

    private(set) var entries: [JournalEntry] = []
    private(set) var error: AppError?
    private(set) var isLoading = false

    // MARK: - Initialization

    init(
        journalService: JournalDataService,
        errorHandler: ErrorHandlingService
    ) {
        self.journalService = journalService
        self.errorHandler = errorHandler
    }

    /// Convenience initializer for previews
    convenience init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Streak.self, JournalEntry.self, configurations: config)
        let context = container.mainContext
        self.init(
            journalService: SwiftDataJournalService(modelContext: context),
            errorHandler: AppErrorHandler()
        )
    }

    // MARK: - Setup

    func setup() async {
        await fetchEntries()
    }

    // MARK: - Data Operations

    func fetchEntries() async {
        isLoading = true
        defer { isLoading = false }

        do {
            entries = try await journalService.fetchAll()
        } catch {
            self.error = AppError.from(error)
            errorHandler.log(error, context: "JournalViewModel.fetchEntries")
        }
    }

    func addEntry(energy: Int, confidence: Int, focus: Int, mood: Int, note: String?) async throws {
        // Input validation
        guard (Constants.Mood.range).contains(energy) else {
            throw AppError.validationFailed("Energy must be between \(Constants.Mood.minScore) and \(Constants.Mood.maxScore)")
        }
        guard (Constants.Mood.range).contains(confidence) else {
            throw AppError.validationFailed("Confidence must be between \(Constants.Mood.minScore) and \(Constants.Mood.maxScore)")
        }
        guard (Constants.Mood.range).contains(focus) else {
            throw AppError.validationFailed("Focus must be between \(Constants.Mood.minScore) and \(Constants.Mood.maxScore)")
        }
        guard (Constants.Mood.range).contains(mood) else {
            throw AppError.validationFailed("Mood must be between \(Constants.Mood.minScore) and \(Constants.Mood.maxScore)")
        }

        do {
            _ = try await journalService.createEntry(
                energy: energy,
                confidence: confidence,
                focus: focus,
                mood: mood,
                note: note
            )
            await fetchEntries()
        } catch {
            self.error = AppError.from(error)
            errorHandler.log(error, context: "JournalViewModel.addEntry")
            throw error
        }
    }

    func deleteEntry(_ entry: JournalEntry) async {
        do {
            try await journalService.delete(entry)
            await fetchEntries()
        } catch {
            self.error = AppError.from(error)
            errorHandler.log(error, context: "JournalViewModel.deleteEntry")
        }
    }

    // MARK: - Computed Properties

    var hasCheckedInToday: Bool {
        guard let latest = entries.first else { return false }
        return Calendar.current.isDateInToday(latest.date)
    }

    var averageMood: Double {
        guard !entries.isEmpty else { return 0 }
        return Double(entries.reduce(0) { $0 + $1.mood }) / Double(entries.count)
    }

    var recentEntries: [JournalEntry] {
        Array(entries.prefix(7))
    }

    func entriesForPeriod(days: Int) -> [JournalEntry] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: .now) ?? .now
        return entries.filter { $0.date >= cutoff }
    }

    // MARK: - Error Handling

    func clearError() {
        error = nil
    }
}
