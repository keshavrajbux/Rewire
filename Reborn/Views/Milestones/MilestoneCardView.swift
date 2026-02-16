import SwiftUI

struct MilestoneCardView: View {
    let milestone: Milestone
    let currentDays: Int

    @State private var appeared = false
    @State private var shimmerOffset: CGFloat = -200

    var isUnlocked: Bool {
        milestone.isUnlocked
    }

    var body: some View {
        HStack(spacing: Theme.paddingMedium) {
            // Timeline indicator
            VStack(spacing: 0) {
                // Circle indicator
                ZStack {
                    Circle()
                        .fill(isUnlocked ? Theme.neonBlue : Theme.cardBlack)
                        .frame(width: 20, height: 20)

                    if isUnlocked {
                        Circle()
                            .fill(Theme.successGreen)
                            .frame(width: 10, height: 10)
                    }
                }
                .shadow(color: isUnlocked ? Theme.neonBlue.opacity(0.5) : .clear, radius: 8)

                // Connecting line
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: isUnlocked
                                ? [Theme.neonBlue.opacity(0.5), Theme.neonBlue.opacity(0.2)]
                                : [Theme.cardBlack, Theme.cardBlack.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 2)
            }

            // Card content
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    // Icon with glow
                    ZStack {
                        if isUnlocked {
                            Circle()
                                .fill(Theme.neonBlue.opacity(0.15))
                                .frame(width: 44, height: 44)
                        }

                        Image(systemName: milestone.icon)
                            .font(.title2)
                            .foregroundStyle(isUnlocked ? Theme.neonBlue : Theme.textTertiary)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(milestone.title)
                            .font(.headline)
                            .foregroundStyle(isUnlocked ? .white : Theme.textTertiary)

                        Text("Day \(milestone.days)")
                            .font(.caption)
                            .foregroundStyle(isUnlocked ? Theme.neonBlue : Theme.textTertiary)
                    }

                    Spacer()

                    if isUnlocked {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title3)
                            .foregroundStyle(Theme.successGreen)
                            .shadow(color: Theme.successGreen.opacity(0.5), radius: 6)
                    } else {
                        // Progress indicator for locked milestones
                        let progress = min(Double(currentDays) / Double(milestone.days), 1.0)
                        ZStack {
                            Circle()
                                .stroke(Theme.textTertiary.opacity(0.3), lineWidth: 3)
                                .frame(width: 36, height: 36)

                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(Theme.royalViolet.opacity(0.6), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .frame(width: 36, height: 36)
                                .rotationEffect(.degrees(-90))

                            Image(systemName: "lock.fill")
                                .font(.caption)
                                .foregroundStyle(Theme.textTertiary)
                        }
                    }
                }

                Text(milestone.description)
                    .font(.subheadline)
                    .foregroundStyle(isUnlocked ? Theme.textSecondary : Theme.textTertiary)
                    .lineLimit(2)

                // Science fact (only for unlocked)
                if isUnlocked {
                    HStack(spacing: 8) {
                        Image(systemName: "brain.head.profile")
                            .font(.caption2)
                            .foregroundStyle(Theme.royalViolet)

                        Text(milestone.scienceFact)
                            .font(.caption2)
                            .foregroundStyle(Theme.textSecondary)
                            .lineLimit(3)
                    }
                    .padding(10)
                    .background(Theme.royalViolet.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
                    .overlay(
                        // Shimmer effect for unlocked cards
                        RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall)
                            .fill(
                                LinearGradient(
                                    colors: [.clear, .white.opacity(0.1), .clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: shimmerOffset)
                            .mask(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
                    )
                }
            }
            .padding(Theme.paddingMedium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(Theme.cardBlack)
                    .shadow(color: isUnlocked ? Theme.neonBlue.opacity(0.1) : .clear, radius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(
                        isUnlocked
                            ? LinearGradient(
                                colors: [Theme.neonBlue.opacity(0.3), Theme.royalViolet.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [Color.white.opacity(0.05), Color.white.opacity(0.02)],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                        lineWidth: 1
                    )
            )
            .opacity(isUnlocked ? 1 : 0.7)
        }
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : 20)
        .onAppear {
            withAnimation(Animations.smooth.delay(Double(milestone.days) * 0.01)) {
                appeared = true
            }

            // Start shimmer animation for unlocked cards
            if isUnlocked {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false).delay(Double.random(in: 0...2))) {
                    shimmerOffset = 200
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        VStack(spacing: 0) {
            MilestoneCardView(
                milestone: Milestone.all[0],
                currentDays: 5
            )
            MilestoneCardView(
                milestone: Milestone.all[2],
                currentDays: 5
            )
            MilestoneCardView(
                milestone: Milestone.all[4],
                currentDays: 5
            )
        }
        .padding()
    }
}
