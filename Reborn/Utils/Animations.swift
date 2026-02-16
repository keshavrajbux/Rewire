import SwiftUI

/// Animation presets and helpers for cinematic effects
enum Animations {
    // MARK: - Spring Presets

    /// Quick, snappy interaction feedback
    static let snappy = Animation.spring(response: 0.3, dampingFraction: 0.7)

    /// Smooth, natural movement
    static let smooth = Animation.spring(response: 0.5, dampingFraction: 0.8)

    /// Bouncy, playful animation
    static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)

    /// Gentle, subtle animation
    static let gentle = Animation.spring(response: 0.6, dampingFraction: 0.9)

    /// Dramatic, cinematic entrance
    static let dramatic = Animation.spring(response: 0.8, dampingFraction: 0.7)

    // MARK: - Timing Curves

    /// Ease out for exits
    static let easeOut = Animation.easeOut(duration: Constants.Animation.standard)

    /// Ease in for entrances
    static let easeIn = Animation.easeIn(duration: Constants.Animation.standard)

    /// Smooth ease in-out
    static let easeInOut = Animation.easeInOut(duration: Constants.Animation.smooth)

    // MARK: - Staggered Animations

    /// Calculate stagger delay for index
    static func staggerDelay(for index: Int) -> Double {
        Double(index) * Constants.Animation.staggerDelay
    }

    /// Animation with stagger delay
    static func staggered(index: Int, animation: Animation = smooth) -> Animation {
        animation.delay(staggerDelay(for: index))
    }

    /// Netflix-style row stagger (slightly longer delays)
    static func rowStagger(for index: Int) -> Animation {
        smooth.delay(Double(index) * Constants.Animation.rowStaggerDelay)
    }

    // MARK: - Special Effects

    /// Pulsing glow animation
    static let pulse = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)

    /// Shimmer sweep animation
    static let shimmer = Animation.linear(duration: 2.0).repeatForever(autoreverses: false)

    /// Breathing animation
    static let breathe = Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)

    /// Celebration bounce
    static let celebration = Animation.spring(response: 0.5, dampingFraction: 0.5)
}

// MARK: - View Extensions

extension View {
    /// Applies a staggered appear animation
    func staggeredAppear(index: Int, isVisible: Bool) -> some View {
        self
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .animation(Animations.staggered(index: index), value: isVisible)
    }

    /// Applies a scale and fade effect
    func scaleAndFade(isVisible: Bool, scale: CGFloat = 0.8) -> some View {
        self
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : scale)
            .animation(Animations.smooth, value: isVisible)
    }

    /// Applies a slide up animation
    func slideUp(isVisible: Bool, offset: CGFloat = 50) -> some View {
        self
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : offset)
            .animation(Animations.smooth, value: isVisible)
    }

    /// Shimmer overlay effect
    func shimmerEffect(isAnimating: Bool) -> some View {
        self.overlay(
            GeometryReader { geo in
                Theme.shimmerGradient
                    .frame(width: geo.size.width * 2)
                    .offset(x: isAnimating ? geo.size.width : -geo.size.width)
            }
            .mask(self)
        )
    }
}

// MARK: - Staggered Reveal Container

/// A container that reveals its children with staggered animations
struct StaggeredReveal<Content: View>: View {
    let animation: Animation
    let delay: Double
    @ViewBuilder let content: () -> Content

    @State private var isVisible = false

    init(
        animation: Animation = Animations.smooth,
        delay: Double = 0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.animation = animation
        self.delay = delay
        self.content = content
    }

    var body: some View {
        content()
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(animation.delay(delay)) {
                    isVisible = true
                }
            }
    }
}

// MARK: - Animated Counter

/// Animates number changes with a counting effect
struct AnimatedCounter: View {
    let value: Int
    let font: Font
    let color: Color

    @State private var displayedValue: Int = 0

    var body: some View {
        Text("\(displayedValue)")
            .font(font)
            .foregroundStyle(color)
            .contentTransition(.numericText())
            .onChange(of: value, initial: true) { _, newValue in
                withAnimation(Animations.snappy) {
                    displayedValue = newValue
                }
            }
    }
}

// MARK: - Parallax Modifier

struct ParallaxModifier: ViewModifier {
    let offset: CGFloat
    let multiplier: CGFloat

    func body(content: Content) -> some View {
        content
            .offset(y: offset * multiplier)
    }
}

extension View {
    func parallax(offset: CGFloat, multiplier: CGFloat = 0.5) -> some View {
        modifier(ParallaxModifier(offset: offset, multiplier: multiplier))
    }
}
