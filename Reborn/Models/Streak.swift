import Foundation
import SwiftData

@Model
final class Streak {
    var id: UUID
    var startDate: Date
    var endDate: Date?
    var isActive: Bool

    init(startDate: Date = .now, endDate: Date? = nil, isActive: Bool = true) {
        self.id = UUID()
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = isActive
    }

    var duration: TimeInterval {
        let end = endDate ?? Date.now
        return end.timeIntervalSince(startDate)
    }

    var days: Int {
        Int(duration / 86400)
    }

    var hours: Int {
        Int(duration.truncatingRemainder(dividingBy: 86400) / 3600)
    }

    var minutes: Int {
        Int(duration.truncatingRemainder(dividingBy: 3600) / 60)
    }

    var seconds: Int {
        Int(duration.truncatingRemainder(dividingBy: 60))
    }
}
