import Foundation

/// Centralized error type for the Reborn app
/// Provides user-friendly messages and recovery suggestions
enum AppError: LocalizedError, Equatable {
    case dataFetchFailure(String)
    case dataSaveFailure(String)
    case dataDeleteFailure(String)
    case invalidInput(String)
    case streakNotFound
    case journalEntryNotFound
    case validationFailed(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .dataFetchFailure(let detail):
            return "Unable to load data: \(detail)"
        case .dataSaveFailure(let detail):
            return "Unable to save: \(detail)"
        case .dataDeleteFailure(let detail):
            return "Unable to delete: \(detail)"
        case .invalidInput(let detail):
            return "Invalid input: \(detail)"
        case .streakNotFound:
            return "No active streak found"
        case .journalEntryNotFound:
            return "Journal entry not found"
        case .validationFailed(let detail):
            return "Validation failed: \(detail)"
        case .unknown(let detail):
            return "An unexpected error occurred: \(detail)"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .dataFetchFailure:
            return "Please try again or restart the app."
        case .dataSaveFailure:
            return "Make sure you have enough storage space and try again."
        case .dataDeleteFailure:
            return "Please try again."
        case .invalidInput:
            return "Please check your input and try again."
        case .streakNotFound:
            return "Start a new streak to begin tracking."
        case .journalEntryNotFound:
            return "The entry may have been deleted."
        case .validationFailed:
            return "Please correct the highlighted fields."
        case .unknown:
            return "Please try again or restart the app."
        }
    }

    /// Create from any Error
    static func from(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        return .unknown(error.localizedDescription)
    }
}
