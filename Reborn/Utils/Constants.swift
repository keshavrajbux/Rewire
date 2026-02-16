import Foundation

/// Centralized constants for the Reborn app
/// Eliminates magic numbers and provides a single source of truth
enum Constants {
    // MARK: - Mood & Metrics

    enum Mood {
        static let minScore = 1
        static let maxScore = 10
        static let defaultScore = 5
        static let range = minScore...maxScore
    }

    // MARK: - Milestones

    enum Milestones {
        static let dayThresholds = [1, 3, 7, 14, 30, 60, 90, 180, 365]
        static let totalCount = dayThresholds.count
    }

    // MARK: - Animation Durations

    enum Animation {
        static let quick: Double = 0.2
        static let standard: Double = 0.3
        static let smooth: Double = 0.5
        static let dramatic: Double = 0.8
        static let slow: Double = 1.0
        static let veryLong: Double = 1.5

        // Stagger delays
        static let staggerDelay: Double = 0.05
        static let rowStaggerDelay: Double = 0.08
    }

    // MARK: - Timer Intervals

    enum Timer {
        static let streakUpdateInterval: TimeInterval = 1.0
        static let breathingCountdown: TimeInterval = 1.0
    }

    // MARK: - Breathing Exercise (4-7-8)

    enum Breathing {
        static let inhaleSeconds = 4
        static let holdSeconds = 7
        static let exhaleSeconds = 8
    }

    // MARK: - Time Periods

    enum TimePeriod {
        static let week = 7
        static let month = 30
        static let quarter = 90
        static let year = 365
        static let allTime = 365 * 10
    }

    // MARK: - Layout

    enum Layout {
        static let streakRingSize: CGFloat = 280
        static let streakRingLineWidth: CGFloat = 14
        static let minCardHeight: CGFloat = 100
        static let tabBarHeight: CGFloat = 70
        static let tabBarBottomPadding: CGFloat = 20
    }

    // MARK: - Haptics

    enum Haptics {
        static let buttonImpactIntensity: CGFloat = 0.6
        static let celebrationImpactIntensity: CGFloat = 1.0
    }
}
