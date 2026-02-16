import SwiftUI

// MARK: - Custom Transitions

extension AnyTransition {
    /// Cinematic fade with scale - asymmetric for insert/removal
    static var cinematicFade: AnyTransition {
        .asymmetric(
            insertion: .opacity
                .combined(with: .scale(scale: 0.95))
                .animation(Animations.smooth),
            removal: .opacity
                .combined(with: .scale(scale: 1.02))
                .animation(Animations.easeOut)
        )
    }

    /// Slide up from bottom with fade
    static var slideUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom)
                .combined(with: .opacity)
                .animation(Animations.smooth),
            removal: .move(edge: .bottom)
                .combined(with: .opacity)
                .animation(Animations.easeOut)
        )
    }

    /// Hero expand for fullscreen covers
    static var heroExpand: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.9)
                .combined(with: .opacity)
                .animation(Animations.dramatic),
            removal: .scale(scale: 0.95)
                .combined(with: .opacity)
                .animation(Animations.smooth)
        )
    }

    /// Scale in from center
    static var scaleIn: AnyTransition {
        .scale(scale: 0)
            .combined(with: .opacity)
            .animation(Animations.bouncy)
    }

    /// Blur fade for overlay content
    static var blurFade: AnyTransition {
        .modifier(
            active: BlurFadeModifier(isActive: true),
            identity: BlurFadeModifier(isActive: false)
        )
    }

    /// Card flip transition
    static var cardFlip: AnyTransition {
        .modifier(
            active: CardFlipModifier(isFlipped: true),
            identity: CardFlipModifier(isFlipped: false)
        )
    }
}

// MARK: - Blur Fade Modifier

struct BlurFadeModifier: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .blur(radius: isActive ? 10 : 0)
            .opacity(isActive ? 0 : 1)
    }
}

// MARK: - Card Flip Modifier

struct CardFlipModifier: ViewModifier {
    let isFlipped: Bool

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(isFlipped ? 90 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
            .opacity(isFlipped ? 0 : 1)
    }
}

// MARK: - Scroll Transition Helpers

extension View {
    /// Apply scroll-based transition effects
    @ViewBuilder
    func scrollTransitionEffect(
        topLeading: Edge.Set = .top,
        bottomTrailing: Edge.Set = .bottom
    ) -> some View {
        if #available(iOS 17.0, *) {
            self.scrollTransition(.interactive) { content, phase in
                content
                    .opacity(phase.isIdentity ? 1 : 0.7)
                    .scaleEffect(phase.isIdentity ? 1 : 0.95)
                    .blur(radius: phase.isIdentity ? 0 : 2)
            }
        } else {
            self
        }
    }

    /// Carousel item effect with scale and opacity
    @ViewBuilder
    func carouselItemEffect() -> some View {
        if #available(iOS 17.0, *) {
            self.scrollTransition(.interactive) { content, phase in
                content
                    .opacity(phase.isIdentity ? 1 : 0.6)
                    .scaleEffect(
                        x: phase.isIdentity ? 1 : 0.9,
                        y: phase.isIdentity ? 1 : 0.9
                    )
            }
        } else {
            self
        }
    }
}

// MARK: - Tab Change Transition

struct TabTransition: ViewModifier {
    let isSelected: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isSelected ? 1 : 0)
            .scaleEffect(isSelected ? 1 : 0.95)
            .animation(Animations.snappy, value: isSelected)
    }
}

extension View {
    func tabTransition(isSelected: Bool) -> some View {
        modifier(TabTransition(isSelected: isSelected))
    }
}

// MARK: - Matched Geometry Transition

struct MatchedTransitionModifier: ViewModifier {
    let id: AnyHashable
    let namespace: Namespace.ID
    let isSource: Bool

    func body(content: Content) -> some View {
        content
            .matchedGeometryEffect(id: id, in: namespace, isSource: isSource)
    }
}

extension View {
    func matchedTransition(
        id: AnyHashable,
        in namespace: Namespace.ID,
        isSource: Bool = true
    ) -> some View {
        modifier(MatchedTransitionModifier(id: id, namespace: namespace, isSource: isSource))
    }
}
