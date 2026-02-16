import SwiftUI

struct MilestonesView: View {
    @Bindable var milestoneVM: MilestoneViewModel
    let currentDays: Int

    @State private var isContentVisible = false

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    LazyVStack(spacing: 0) {
                        // Hero progress header
                        progressHeader
                            .staggeredAppear(index: 0, isVisible: isContentVisible)

                        // Timeline
                        ForEach(Array(milestoneVM.milestones.enumerated()), id: \.element.id) { index, milestone in
                            MilestoneCardView(
                                milestone: milestone,
                                currentDays: currentDays
                            )
                            .staggeredAppear(index: index + 1, isVisible: isContentVisible)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
            .navigationTitle("Milestones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .overlay {
            if milestoneVM.showCelebration, let milestone = milestoneVM.newlyUnlockedMilestone {
                CelebrationOverlay(milestone: milestone) {
                    milestoneVM.dismissCelebration()
                }
            }
        }
        .onAppear {
            withAnimation(Animations.smooth.delay(0.1)) {
                isContentVisible = true
            }
        }
    }

    private var progressHeader: some View {
        VStack(spacing: Theme.paddingMedium) {
            // Large progress display
            ZStack {
                Circle()
                    .stroke(Theme.royalViolet.opacity(0.2), lineWidth: 8)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0, to: Double(milestoneVM.unlockedCount) / Double(milestoneVM.totalCount))
                    .stroke(
                        LinearGradient(
                            colors: [Theme.neonBlue, Theme.royalViolet],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: Theme.royalViolet.opacity(0.5), radius: 10)

                VStack(spacing: 2) {
                    Text("\(milestoneVM.unlockedCount)")
                        .font(Theme.Typography.largeTitle)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())

                    Text("of \(milestoneVM.totalCount)")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }
            }

            Text("Milestones Unlocked")
                .font(Theme.Typography.credits)
                .foregroundStyle(Theme.textSecondary)
                .textCase(.uppercase)
                .tracking(2)

            // Next milestone countdown
            if let next = milestoneVM.nextMilestone,
               let daysLeft = milestoneVM.daysUntilNext(currentDays: currentDays) {
                HStack(spacing: 6) {
                    Image(systemName: next.icon)
                        .foregroundStyle(Theme.neonBlue)

                    Text("\(daysLeft) days until \(next.title)")
                        .font(.subheadline)
                        .foregroundStyle(Theme.neonBlue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Theme.neonBlue.opacity(0.1))
                .clipShape(Capsule())
            }
        }
        .padding(.vertical, Theme.paddingXL)
    }
}

// MARK: - Celebration Overlay

struct CelebrationOverlay: View {
    let milestone: Milestone
    let onDismiss: () -> Void

    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var confettiActive = false

    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.9)
                .ignoresSafeArea()
                .opacity(opacity)
                .onTapGesture { onDismiss() }

            // Content
            VStack(spacing: Theme.paddingLarge) {
                // Icon with glow
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Theme.neonBlue.opacity(0.3), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)

                    Circle()
                        .fill(Theme.neonBlue.opacity(0.15))
                        .frame(width: 100, height: 100)

                    Image(systemName: milestone.icon)
                        .font(.system(size: 50))
                        .foregroundStyle(Theme.neonBlue)
                        .shadow(color: Theme.neonBlue.opacity(0.5), radius: 20)
                }

                VStack(spacing: 8) {
                    Text("MILESTONE UNLOCKED")
                        .font(Theme.Typography.credits)
                        .foregroundStyle(Theme.neonBlue)
                        .textCase(.uppercase)
                        .tracking(4)

                    Text(milestone.title)
                        .font(Theme.Typography.title)
                        .foregroundStyle(.white)

                    Text(milestone.description)
                        .font(.body)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                // Science fact
                HStack(spacing: 8) {
                    Image(systemName: "brain.head.profile")
                        .foregroundStyle(Theme.royalViolet)

                    Text(milestone.scienceFact)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
                .padding(Theme.paddingMedium)
                .background(Theme.royalViolet.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                .padding(.horizontal, 24)

                GlowingButton(title: "Continue", icon: "arrow.right") {
                    onDismiss()
                }
                .padding(.top, Theme.paddingMedium)
            }
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(Animations.dramatic) {
                scale = 1.0
                opacity = 1.0
            }
            confettiActive = true
        }
    }
}

#Preview {
    MilestonesView(milestoneVM: MilestoneViewModel(), currentDays: 10)
        .preferredColorScheme(.dark)
}
