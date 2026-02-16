import SwiftUI

struct MotivationCardView: View {
    let quote: Quote

    var body: some View {
        VStack(spacing: Theme.paddingMedium) {
            // Quote icon
            ZStack {
                Circle()
                    .fill(Theme.royalViolet.opacity(0.15))
                    .frame(width: 50, height: 50)

                Image(systemName: "quote.opening")
                    .font(.title2)
                    .foregroundStyle(Theme.royalViolet)
            }

            Text(quote.text)
                .font(.body)
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
                .italic()
                .lineSpacing(4)

            Text("— \(quote.author)")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
        }
        .padding(Theme.paddingLarge)
        .frame(maxWidth: .infinity)
        .cinematicCard(glowColor: Theme.royalViolet)
    }
}

struct MotivationCardsSection: View {
    @State private var currentIndex = 0
    private let quotes = Quotes.motivational.shuffled()

    var body: some View {
        VStack(spacing: Theme.paddingLarge) {
            // Header
            VStack(spacing: 8) {
                Text("STAY STRONG")
                    .font(Theme.Typography.credits)
                    .foregroundStyle(Theme.crimson)
                    .tracking(3)

                Text("You are stronger than this urge")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textPrimary)
            }

            // Quote carousel
            TabView(selection: $currentIndex) {
                ForEach(Array(quotes.enumerated()), id: \.element.id) { index, quote in
                    MotivationCardView(quote: quote)
                        .padding(.horizontal, 8)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 240)

            // Brain Science Fact
            brainScienceFact
        }
    }

    private var brainScienceFact: some View {
        VStack(spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Theme.successGreen.opacity(0.15))
                        .frame(width: 36, height: 36)

                    Image(systemName: "brain.head.profile")
                        .font(.subheadline)
                        .foregroundStyle(Theme.successGreen)
                }

                Text("Brain Science")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.successGreen)

                Spacer()
            }

            Text(Quotes.randomBrainFact())
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
                .lineSpacing(3)
        }
        .padding(Theme.paddingMedium)
        .cinematicCard(glowColor: Theme.successGreen)
    }
}

#Preview {
    ZStack {
        Theme.sosGradient.ignoresSafeArea()
        MotivationCardsSection()
            .padding()
    }
}
