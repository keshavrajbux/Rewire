import SwiftUI

enum Theme {
    // MARK: - Colors
    static let electricBlue = Color(hex: "4F7BF7")
    static let violet = Color(hex: "8B5CF6")
    static let successGreen = Color(hex: "34D399")
    static let warningRed = Color(hex: "EF4444")
    static let darkBackground = Color(hex: "0A0A1A")
    static let cardBackground = Color(hex: "1A1A2E")
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    static let textTertiary = Color.white.opacity(0.4)

    // MARK: - Gradients
    static let primaryGradient = LinearGradient(
        colors: [violet, electricBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let backgroundGradient = LinearGradient(
        colors: [Color(hex: "0A0A1A"), Color(hex: "1A0A2E"), Color(hex: "0A1A2E")],
        startPoint: .top,
        endPoint: .bottom
    )

    static let streakRingGradient = AngularGradient(
        colors: [electricBlue, violet, electricBlue],
        center: .center
    )

    static let sosGradient = LinearGradient(
        colors: [Color(hex: "7F1D1D"), Color(hex: "1A0A2E")],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Spacing
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let paddingXL: CGFloat = 32

    // MARK: - Corner Radius
    static let cornerRadius: CGFloat = 16
    static let cornerRadiusSmall: CGFloat = 10
    static let cornerRadiusLarge: CGFloat = 24

    // MARK: - Card Style
    static func cardStyle() -> some ViewModifier {
        CardModifier()
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
