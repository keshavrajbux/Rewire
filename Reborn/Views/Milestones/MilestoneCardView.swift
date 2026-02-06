import SwiftUI

struct MilestoneCardView: View {
    let milestone: Milestone
    let currentDays: Int

    @State private var appeared = false

    var isUnlocked: Bool {
        milestone.isUnlocked
    }

    var body: some View {
        HStack(spacing: 16) {
            // Timeline indicator
            VStack(spacing: 0) {
                Circle()
                    .fill(isUnlocked ? Theme.electricBlue : Color.white.opacity(0.2))
                    .frame(width: 14, height: 14)
                    .overlay(
                        Circle()
                            .fill(isUnlocked ? Theme.successGreen : Color.clear)
                            .frame(width: 8, height: 8)
                    )
                    .shadow(color: isUnlocked ? Theme.electricBlue.opacity(0.5) : .clear, radius: 6)

                Rectangle()
                    .fill(isUnlocked ? Theme.electricBlue.opacity(0.3) : Color.white.opacity(0.1))
                    .frame(width: 2)
            }

            // Card content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: milestone.icon)
                        .font(.title2)
                        .foregroundStyle(isUnlocked ? Theme.electricBlue : Theme.textTertiary)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(milestone.title)
                            .font(.headline)
                            .foregroundStyle(isUnlocked ? .white : Theme.textTertiary)

                        Text("Day \(milestone.days)")
                            .font(.caption)
                            .foregroundStyle(isUnlocked ? Theme.electricBlue : Theme.textTertiary)
                    }

                    Spacer()

                    if isUnlocked {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Theme.successGreen)
                    } else {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(Theme.textTertiary)
                    }
                }

                Text(milestone.description)
                    .font(.subheadline)
                    .foregroundStyle(isUnlocked ? Theme.textSecondary : Theme.textTertiary)

                if isUnlocked {
                    HStack(spacing: 6) {
                        Image(systemName: "brain.head.profile")
                            .font(.caption2)
                            .foregroundStyle(Theme.violet)

                        Text(milestone.scienceFact)
                            .font(.caption2)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(10)
                    .background(Theme.violet.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardStyle()
            .opacity(isUnlocked ? 1 : 0.6)
        }
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : 20)
        .onAppear {
            withAnimation(.spring(duration: 0.5).delay(Double(milestone.days) * 0.02)) {
                appeared = true
            }
        }
    }
}

#Preview {
    ZStack {
        GradientBackground()
        VStack(spacing: 0) {
            MilestoneCardView(
                milestone: Milestone.all[0],
                currentDays: 5
            )
            MilestoneCardView(
                milestone: Milestone.all[2],
                currentDays: 5
            )
        }
        .padding()
    }
}
