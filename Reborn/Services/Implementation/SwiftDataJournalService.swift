import Foundation
import SwiftData

/// SwiftData implementation of JournalDataService
@MainActor
final class SwiftDataJournalService: JournalDataService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    nonisolated func fetchAll() async throws -> [JournalEntry] {
        try await MainActor.run {
            let descriptor = FetchDescriptor<JournalEntry>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            return try modelContext.fetch(descriptor)
        }
    }

    nonisolated func entriesForPeriod(days: Int) async throws -> [JournalEntry] {
        try await MainActor.run {
            let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: .now) ?? .now
            let descriptor = FetchDescriptor<JournalEntry>(
                predicate: #Predicate { $0.date >= cutoff },
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            return try modelContext.fetch(descriptor)
        }
    }

    nonisolated func hasCheckedInToday() async throws -> Bool {
        try await MainActor.run {
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: Date.now)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? .now

            let descriptor = FetchDescriptor<JournalEntry>(
                predicate: #Predicate { $0.date >= startOfDay && $0.date < endOfDay }
            )
            return try !modelContext.fetch(descriptor).isEmpty
        }
    }

    nonisolated func save(_ entry: JournalEntry) async throws {
        try await MainActor.run {
            modelContext.insert(entry)
            try modelContext.save()
        }
    }

    nonisolated func delete(_ entry: JournalEntry) async throws {
        try await MainActor.run {
            modelContext.delete(entry)
            try modelContext.save()
        }
    }

    nonisolated func createEntry(
        energy: Int,
        confidence: Int,
        focus: Int,
        mood: Int,
        note: String?
    ) async throws -> JournalEntry {
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

        return try await MainActor.run {
            let entry = JournalEntry(
                energy: energy,
                confidence: confidence,
                focus: focus,
                mood: mood,
                note: note?.isEmpty == true ? nil : note
            )
            modelContext.insert(entry)
            try modelContext.save()
            return entry
        }
    }
}
