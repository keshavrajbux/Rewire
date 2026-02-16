import SwiftUI

enum Theme {
    // MARK: - Sunny Bright Color Palette

    // Light backgrounds
    static let pureWhite = Color(hex: "FFFFFF")
    static let softCream = Color(hex: "FFFDF7")
    static let warmWhite = Color(hex: "FFF9E6")
    static let lightGray = Color(hex: "F5F5F5")

    // Sunny accent colors
    static let sunnyYellow = Color(hex: "FFD60A")
    static let goldenOrange = Color(hex: "FF9500")
    static let warmCoral = Color(hex: "FF6B6B")
    static let freshMint = Color(hex: "34D399")
    static let skyBlue = Color(hex: "38BDF8")
    static let lavender = Color(hex: "A78BFA")

    // Legacy color mappings
    static let neonBlue = skyBlue
    static let royalViolet = lavender
    static let gold = sunnyYellow
    static let crimson = warmCoral
    static let electricBlue = skyBlue
    static let violet = lavender
    static let successGreen = freshMint
    static let warningRed = warmCoral
    static let darkBackground = softCream
    static let cardBackground = pureWhite

    // Elevation colors for cards
    static let deepBlack = softCream
    static let cardBlack = pureWhite
    static let elevatedBlack = pureWhite

    // Text hierarchy (dark text on light backgrounds)
    static let textPrimary = Color(hex: "1A1A1A")
    static let textSecondary = Color(hex: "4A4A4A")
    static let textTertiary = Color(hex: "8A8A8A")
    static let textMuted = Color(hex: "BCBCBC")

    // MARK: - Gradients

    static let primaryGradient = LinearGradient(
        colors: [sunnyYellow, goldenOrange],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let backgroundGradient = LinearGradient(
        colors: [softCream, warmWhite, Color(hex: "FFF5E1")],
        startPoint: .top,
        endPoint: .bottom
    )

    static let streakRingGradient = AngularGradient(
        colors: [sunnyYellow, goldenOrange, warmCoral, sunnyYellow],
        center: .center
    )

    static let sosGradient = LinearGradient(
        colors: [Color(hex: "FFF0F0"), Color(hex: "FFE4E4")],
        startPoint: .top,
        endPoint: .bottom
    )

    static let goldGradient = LinearGradient(
        colors: [sunnyYellow, goldenOrange],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let shimmerGradient = LinearGradient(
        colors: [.clear, .white.opacity(0.8), .clear],
        startPoint: .leading,
        endPoint: .trailing
    )

    // MARK: - Spacing

    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let paddingXL: CGFloat = 32
    static let paddingXXL: CGFloat = 48

    // MARK: - Corner Radius

    static let cornerRadiusSmall: CGFloat = 10
    static let cornerRadius: CGFloat = 16
    static let cornerRadiusLarge: CGFloat = 24
    static let cornerRadiusXL: CGFloat = 32

    // MARK: - Shadows

    static func glowShadow(color: Color, radius: CGFloat = 20) -> some View {
        color.opacity(0.3).blur(radius: radius)
    }

    // MARK: - Typography

    enum Typography {
        static let heroDisplay = Font.system(size: 72, weight: .bold, design: .rounded)
        static let largeTitle = Font.system(size: 48, weight: .bold, design: .rounded)
        static let title = Font.system(size: 28, weight: .bold, design: .rounded)
        static let headline = Font.system(size: 18, weight: .semibold, design: .default)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let caption = Font.system(size: 14, weight: .medium, design: .default)
        static let timerMono = Font.system(size: 18, weight: .medium, design: .monospaced)

        // Movie credits style
        static let credits = Font.system(size: 12, weight: .medium, design: .default)
    }

    // MARK: - Card Style

    static func cardStyle() -> some ViewModifier {
        CardModifier()
    }
}

// MARK: - Card Modifier

struct CardModifier: ViewModifier {
    var elevation: CardElevation = .surface

    enum CardElevation {
        case surface
        case raised
        case floating

        var backgroundColor: Color {
            switch self {
            case .surface: return Theme.pureWhite
            case .raised: return Theme.pureWhite
            case .floating: return Theme.pureWhite
            }
        }

        var shadowRadius: CGFloat {
            switch self {
            case .surface: return 8
            case .raised: return 16
            case .floating: return 24
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(elevation.backgroundColor)
                    .shadow(color: Color.black.opacity(0.06), radius: elevation.shadowRadius / 2, y: 2)
                    .shadow(color: Color.black.opacity(0.04), radius: elevation.shadowRadius, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            )
    }
}

extension View {
    func cardStyle(elevation: CardModifier.CardElevation = .surface) -> some View {
        modifier(CardModifier(elevation: elevation))
    }
}

// MARK: - Sunny Card Modifier

struct CinematicCardModifier: ViewModifier {
    var glowColor: Color = Theme.sunnyYellow

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Soft glow
                    RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                        .fill(glowColor.opacity(0.1))
                        .blur(radius: 15)

                    // Card background
                    RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                        .fill(Theme.pureWhite)

                    // Soft shadow
                    RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                        .fill(.clear)
                        .shadow(color: Color.black.opacity(0.08), radius: 12, y: 4)
                        .shadow(color: glowColor.opacity(0.15), radius: 20, y: 0)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                    .stroke(
                        LinearGradient(
                            colors: [glowColor.opacity(0.3), Color.black.opacity(0.05), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

extension View {
    func cinematicCard(glowColor: Color = Theme.sunnyYellow) -> some View {
        modifier(CinematicCardModifier(glowColor: glowColor))
    }
}

// MARK: - Gradient Text Modifier

struct GradientTextModifier: ViewModifier {
    var gradient: LinearGradient

    func body(content: Content) -> some View {
        content
            .overlay(gradient)
            .mask(content)
    }
}

extension View {
    func gradientForeground(_ gradient: LinearGradient = Theme.primaryGradient) -> some View {
        modifier(GradientTextModifier(gradient: gradient))
    }
}

// MARK: - Color Extension

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
