import SwiftUI

/// Netflix-style horizontal carousel with scroll effects
struct CinematicCarousel<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let data: Data
    let itemWidth: CGFloat
    let spacing: CGFloat
    @ViewBuilder let content: (Data.Element) -> Content

    @State private var scrollOffset: CGFloat = 0
    @State private var isVisible = false

    init(
        _ data: Data,
        itemWidth: CGFloat = 280,
        spacing: CGFloat = Theme.paddingMedium,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.itemWidth = itemWidth
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: spacing) {
                ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                    content(item)
                        .frame(width: itemWidth)
                        .carouselItemEffect()
                        .opacity(isVisible ? 1 : 0)
                        .offset(x: isVisible ? 0 : 50)
                        .animation(
                            Animations.smooth.delay(Double(index) * 0.05),
                            value: isVisible
                        )
                }
            }
            .padding(.horizontal, Theme.paddingLarge)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .onAppear {
            isVisible = true
        }
    }
}

/// Simple card for carousel items
struct CarouselCard<Content: View>: View {
    let glowColor: Color
    @ViewBuilder let content: () -> Content

    init(
        glowColor: Color = Theme.neonBlue,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.glowColor = glowColor
        self.content = content
    }

    var body: some View {
        content()
            .padding(Theme.paddingMedium)
            .cinematicCard(glowColor: glowColor)
    }
}

/// Quick stats carousel for home screen
struct QuickStatsCarousel: View {
    struct StatItem: Identifiable {
        let id = UUID()
        let title: String
        let value: String
        let unit: String
        let icon: String
        let color: Color
    }

    let stats: [StatItem]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Theme.paddingMedium) {
                ForEach(Array(stats.enumerated()), id: \.element.id) { index, stat in
                    QuickStatCard(stat: stat)
                        .carouselItemEffect()
                        .staggeredAppear(index: index, isVisible: true)
                }
            }
            .padding(.horizontal, Theme.paddingLarge)
        }
    }
}

struct QuickStatCard: View {
    let stat: QuickStatsCarousel.StatItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: stat.icon)
                    .font(.title3)
                    .foregroundStyle(stat.color)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(stat.value)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())

                    Text(stat.unit)
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }

                Text(stat.title)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .frame(width: 140)
        .padding(Theme.paddingMedium)
        .background(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .fill(stat.color.opacity(0.1))
        )
        .cardStyle()
    }
}

/// Horizontal scroll with snap behavior
struct SnapCarousel<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let data: Data
    @ViewBuilder let content: (Data.Element) -> Content

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Theme.paddingMedium) {
                ForEach(data) { item in
                    content(item)
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                        .scrollTransitionEffect()
                }
            }
        }
        .scrollTargetBehavior(.paging)
        .contentMargins(.horizontal, Theme.paddingLarge, for: .scrollContent)
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        VStack(spacing: 30) {
            Text("Quick Stats")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            QuickStatsCarousel(stats: [
                .init(title: "Current", value: "14", unit: "days", icon: "flame.fill", color: Theme.neonBlue),
                .init(title: "Longest", value: "30", unit: "days", icon: "trophy.fill", color: Theme.gold),
                .init(title: "Total", value: "120", unit: "days", icon: "calendar", color: Theme.successGreen),
                .init(title: "Journal", value: "28", unit: "entries", icon: "book.fill", color: Theme.royalViolet)
            ])

            Spacer()
        }
        .padding(.top, 50)
    }
}
