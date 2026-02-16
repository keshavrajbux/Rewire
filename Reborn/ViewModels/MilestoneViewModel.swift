import Foundation
import SwiftUI

@MainActor
@Observable
final class MilestoneViewModel {
    // MARK: - State

    private(set) var milestones: [Milestone] = Milestone.all
    private(set) var newlyUnlockedMilestone: Milestone?
    private(set) var showCelebration: Bool = false

    // Persistence key for unlocked milestones
    private let unlockedMilestonesKey = "unlockedMilestones"

    // MARK: - Initialization

    init() {
        loadUnlockedState()
    }

    // MARK: - Persistence

    private func loadUnlockedState() {
        let unlockedDays = UserDefaults.standard.array(forKey: unlockedMilestonesKey) as? [Int] ?? []
        for i in milestones.indices {
            if unlockedDays.contains(milestones[i].days) {
                milestones[i].isUnlocked = true
            }
        }
    }

    private func saveUnlockedState() {
        let unlockedDays = milestones.filter(\.isUnlocked).map(\.days)
        UserDefaults.standard.set(unlockedDays, forKey: unlockedMilestonesKey)
    }

    // MARK: - Updates

    func updateMilestones(currentStreakDays: Int) {
        let previouslyUnlocked = Set(milestones.filter(\.isUnlocked).map(\.days))

        for i in milestones.indices {
            milestones[i].isUnlocked = currentStreakDays >= milestones[i].days
        }

        // Check for newly unlocked milestones
        if let newest = milestones.last(where: { $0.isUnlocked && !previouslyUnlocked.contains($0.days) }) {
            newlyUnlockedMilestone = newest
            showCelebration = true

            // Haptic feedback for celebration
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred(intensity: Constants.Haptics.celebrationImpactIntensity)
        }

        saveUnlockedState()
    }

    // MARK: - Computed Properties

    var nextMilestone: Milestone? {
        milestones.first(where: { !$0.isUnlocked })
    }

    var unlockedCount: Int {
        milestones.filter(\.isUnlocked).count
    }

    var totalCount: Int {
        milestones.count
    }

    func daysUntilNext(currentDays: Int) -> Int? {
        guard let next = nextMilestone else { return nil }
        return next.days - currentDays
    }

    func progress(currentDays: Int) -> Double {
        guard let next = nextMilestone else { return 1.0 }
        let previous = milestones.last(where: { $0.isUnlocked })?.days ?? 0
        let total = next.days - previous
        let current = currentDays - previous
        guard total > 0 else { return 0 }
        return min(Double(current) / Double(total), 1.0)
    }

    // MARK: - Celebration

    func dismissCelebration() {
        withAnimation(Animations.smooth) {
            showCelebration = false
            newlyUnlockedMilestone = nil
        }
    }

    func triggerCelebration(for milestone: Milestone) {
        newlyUnlockedMilestone = milestone
        showCelebration = true
    }
}
