import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class StreakViewModel {
    private var modelContext: ModelContext?
    private var timer: Timer?

    var currentStreak: Streak?
    var allStreaks: [Streak] = []

    // Live time components
    var days: Int = 0
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchStreaks()
        startTimer()
    }

    private func fetchStreaks() {
        guard let modelContext else { return }

        let descriptor = FetchDescriptor<Streak>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )

        do {
            allStreaks = try modelContext.fetch(descriptor)
            currentStreak = allStreaks.first(where: { $0.isActive })

            if currentStreak == nil {
                startNewStreak()
            }

            updateTimeComponents()
        } catch {
            print("Failed to fetch streaks: \(error)")
        }
    }

    func startNewStreak() {
        guard let modelContext else { return }

        let newStreak = Streak()
        modelContext.insert(newStreak)
        currentStreak = newStreak

        try? modelContext.save()
        fetchStreaks()
    }

    func resetStreak() {
        guard let modelContext, let currentStreak else { return }

        currentStreak.isActive = false
        currentStreak.endDate = Date.now

        try? modelContext.save()

        // Start a new streak
        startNewStreak()
    }

    var longestStreak: Int {
        allStreaks.map { $0.days }.max() ?? 0
    }

    var totalCleanDays: Int {
        allStreaks.reduce(0) { $0 + $1.days }
    }

    var streakCount: Int {
        allStreaks.count
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
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

        days = currentStreak.days
        hours = currentStreak.hours
        minutes = currentStreak.minutes
        seconds = currentStreak.seconds
    }

    func formattedDuration() -> String {
        if days > 0 {
            return "\(days)d \(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else {
            return "\(minutes)m \(seconds)s"
        }
    }

    deinit {
        timer?.invalidate()
    }
}
