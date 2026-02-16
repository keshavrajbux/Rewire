import Foundation

/// Pure function date calculations for streak timing
/// Thread-safe and testable
struct StreakTimeCalculator: DateCalculationService {
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
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
        calendar.isDateInToday(date)
    }

    func dateBySubtracting(days: Int, from date: Date) -> Date {
        calendar.date(byAdding: .day, value: -days, to: date) ?? date
    }
}
