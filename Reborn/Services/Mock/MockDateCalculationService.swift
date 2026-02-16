import Foundation

/// Mock implementation of DateCalculationService for testing
/// Allows controlling time for deterministic tests
struct MockDateCalculationService: DateCalculationService {
    var fixedNow: Date?
    var calendar: Calendar

    init(fixedNow: Date? = nil, calendar: Calendar = .current) {
        self.fixedNow = fixedNow
        self.calendar = calendar
    }

    func components(from startDate: Date, to endDate: Date) -> TimeComponents {
        let duration = endDate.timeIntervalSince(startDate)
        guard duration > 0 else { return .zero }

        let days = Int(duration / 86400)
        let hours = Int(duration.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes = Int(duration.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))

        return TimeComponents(days: days, hours: hours, minutes: minutes, seconds: seconds)
    }

    func daysBetween(_ start: Date, _ end: Date) -> Int {
        let startOfStart = calendar.startOfDay(for: start)
        let startOfEnd = calendar.startOfDay(for: end)
        let components = calendar.dateComponents([.day], from: startOfStart, to: startOfEnd)
        return components.day ?? 0
    }

    func isToday(_ date: Date) -> Bool {
        if let fixedNow {
            return calendar.isDate(date, inSameDayAs: fixedNow)
        }
        return calendar.isDateInToday(date)
    }

    func dateBySubtracting(days: Int, from date: Date) -> Date {
        calendar.date(byAdding: .day, value: -days, to: date) ?? date
    }
}

// MARK: - Test Helpers

extension MockDateCalculationService {
    /// Creates a service with a fixed date for testing
    static func fixed(at date: Date) -> MockDateCalculationService {
        MockDateCalculationService(fixedNow: date)
    }

    /// Creates a service fixed to a specific number of days ago
    static func daysAgo(_ days: Int) -> MockDateCalculationService {
        let date = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return MockDateCalculationService(fixedNow: date)
    }
}
