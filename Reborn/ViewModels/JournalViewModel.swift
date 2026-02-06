import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class JournalViewModel {
    private var modelContext: ModelContext?

    var entries: [JournalEntry] = []

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchEntries()
    }

    func fetchEntries() {
        guard let modelContext else { return }

        let descriptor = FetchDescriptor<JournalEntry>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )

        do {
            entries = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch journal entries: \(error)")
        }
    }

    func addEntry(energy: Int, confidence: Int, focus: Int, mood: Int, note: String?) {
        guard let modelContext else { return }

        let entry = JournalEntry(
            energy: energy,
            confidence: confidence,
            focus: focus,
            mood: mood,
            note: note?.isEmpty == true ? nil : note
        )

        modelContext.insert(entry)
        try? modelContext.save()
        fetchEntries()
    }

    func deleteEntry(_ entry: JournalEntry) {
        guard let modelContext else { return }
        modelContext.delete(entry)
        try? modelContext.save()
        fetchEntries()
    }

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
}
