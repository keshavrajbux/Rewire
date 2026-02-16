import Foundation

/// Time components for displaying streak duration
struct TimeComponents: Equatable, Sendable {
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int

    static let zero = TimeComponents(days: 0, hours: 0, minutes: 0, seconds: 0)

    var formattedDuration: String {
        if days > 0 {
            return "\(days)d \(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else {
            return "\(minutes)m \(seconds)s"
        }
    }

    var timeString: String {
        String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

/// Protocol for date and time calculations
/// Pure functions for calculating durations and intervals
protocol DateCalculationService: Sendable {
    /// Calculate time components between two dates
    func components(from startDate: Date, to endDate: Date) -> TimeComponents

    /// Calculate number of days between two dates
    func daysBetween(_ start: Date, _ end: Date) -> Int

    /// Check if a date is today
    func isToday(_ date: Date) -> Bool

    /// Get the date for a number of days ago
    func dateBySubtracting(days: Int, from date: Date) -> Date
}
