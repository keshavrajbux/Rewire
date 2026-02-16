import Foundation
import OSLog

/// Centralized error handling implementation
/// Logs errors and provides user-friendly messages
final class AppErrorHandler: ErrorHandlingService {
    private let logger = Logger(subsystem: "com.reborn.app", category: "ErrorHandler")

    func handle(_ error: Error) -> String {
        log(error, context: nil)

        if let appError = error as? AppError {
            return appError.localizedDescription
        }

        return "Something went wrong. Please try again."
    }

    func log(_ error: Error, context: String?) {
        let contextPrefix = context.map { "[\($0)] " } ?? ""
        let appError = wrap(error)

        logger.error("\(contextPrefix)\(appError.localizedDescription)")

        #if DEBUG
        print("🔴 Error: \(contextPrefix)\(appError.localizedDescription)")
        if let recovery = appError.recoverySuggestion {
            print("   Recovery: \(recovery)")
        }
        #endif
    }

    func wrap(_ error: Error) -> AppError {
        AppError.from(error)
    }
}
