import SwiftUI

struct MotivationCardView: View {
    let quote: Quote

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lightbulb.fill")
                .font(.title)
                .foregroundStyle(Theme.violet)

            Text(quote.text)
                .font(.body)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .italic()

            Text("- \(quote.author)")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .cardStyle()
    }
}

struct MotivationCardsSection: View {
    @State private var currentIndex = 0
    private let quotes = Quotes.motivational.shuffled()

    var body: some View {
        VStack(spacing: 16) {
            Text("Stay Strong")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)

            TabView(selection: $currentIndex) {
                ForEach(Array(quotes.enumerated()), id: \.element.id) { index, quote in
                    MotivationCardView(quote: quote)
                        .padding(.horizontal, 8)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 220)

            // Brain Science Fact
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .foregroundStyle(Theme.successGreen)
                    Text("Brain Science")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Theme.successGreen)
                }

                Text(Quotes.randomBrainFact())
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .cardStyle()
        }
    }
}

#Preview {
    ZStack {
        Theme.sosGradient.ignoresSafeArea()
        MotivationCardsSection()
            .padding()
    }
}
