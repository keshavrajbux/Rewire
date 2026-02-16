import Foundation

/// Protocol for centralized error handling
/// Replaces scattered print statements with proper error management
protocol ErrorHandlingService: Sendable {
    /// Handle an error and return a user-facing message
    func handle(_ error: Error) -> String

    /// Log an error for debugging (non-blocking)
    func log(_ error: Error, context: String?)

    /// Convert any error to AppError
    func wrap(_ error: Error) -> AppError
}

/// Extension providing default context-less logging
extension ErrorHandlingService {
    func log(_ error: Error) {
        log(error, context: nil)
    }
}
