import Foundation
import SwiftData

@Model
final class JournalEntry {
    var id: UUID
    var date: Date
    var energy: Int
    var confidence: Int
    var focus: Int
    var mood: Int
    var note: String?

    init(date: Date = .now, energy: Int = 5, confidence: Int = 5, focus: Int = 5, mood: Int = 5, note: String? = nil) {
        self.id = UUID()
        self.date = date
        self.energy = energy
        self.confidence = confidence
        self.focus = focus
        self.mood = mood
        self.note = note
    }

    var averageScore: Double {
        Double(energy + confidence + focus + mood) / 4.0
    }

    var moodEmoji: String {
        switch mood {
        case 1...3: return "😔"
        case 4...5: return "😐"
        case 6...7: return "🙂"
        case 8...9: return "😊"
        case 10: return "🤩"
        default: return "😐"
        }
    }
}
