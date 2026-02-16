import Foundation
import SwiftData

/// SwiftData implementation of StreakDataService
@MainActor
final class SwiftDataStreakService: StreakDataService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    nonisolated func fetchAll() async throws -> [Streak] {
        try await MainActor.run {
            let descriptor = FetchDescriptor<Streak>(
                sortBy: [SortDescriptor(\.startDate, order: .reverse)]
            )
            return try modelContext.fetch(descriptor)
        }
    }

    nonisolated func fetchActive() async throws -> Streak? {
        try await MainActor.run {
            let descriptor = FetchDescriptor<Streak>(
                predicate: #Predicate { $0.isActive },
                sortBy: [SortDescriptor(\.startDate, order: .reverse)]
            )
            return try modelContext.fetch(descriptor).first
        }
    }

    nonisolated func save(_ streak: Streak) async throws {
        try await MainActor.run {
            modelContext.insert(streak)
            try modelContext.save()
        }
    }

    nonisolated func delete(_ streak: Streak) async throws {
        try await MainActor.run {
            modelContext.delete(streak)
            try modelContext.save()
        }
    }

    nonisolated func endCurrentStreak() async throws {
        try await MainActor.run {
            let descriptor = FetchDescriptor<Streak>(
                predicate: #Predicate { $0.isActive }
            )
            guard let current = try modelContext.fetch(descriptor).first else {
                throw AppError.streakNotFound
            }
            current.isActive = false
            current.endDate = Date.now
            try modelContext.save()
        }
    }

    nonisolated func startNewStreak() async throws -> Streak {
        try await MainActor.run {
            let newStreak = Streak()
            modelContext.insert(newStreak)
            try modelContext.save()
            return newStreak
        }
    }
}
