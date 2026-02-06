import Foundation
import SwiftUI

@MainActor
@Observable
final class MilestoneViewModel {
    var milestones: [Milestone] = Milestone.all
    var newlyUnlockedMilestone: Milestone?
    var showCelebration: Bool = false

    func updateMilestones(currentStreakDays: Int) {
        let previouslyUnlocked = Set(milestones.filter(\.isUnlocked).map(\.days))

        for i in milestones.indices {
            milestones[i].isUnlocked = currentStreakDays >= milestones[i].days
        }

        // Check for newly unlocked milestones
        if let newest = milestones.last(where: { $0.isUnlocked && !previouslyUnlocked.contains($0.days) }) {
            newlyUnlockedMilestone = newest
            showCelebration = true
        }
    }

    var nextMilestone: Milestone? {
        milestones.first(where: { !$0.isUnlocked })
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

    func dismissCelebration() {
        showCelebration = false
        newlyUnlockedMilestone = nil
    }
}
