import SwiftUI

struct MilestonesView: View {
    @Bindable var milestoneVM: MilestoneViewModel
    let currentDays: Int

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    VStack(spacing: 0) {
                        // Progress header
                        VStack(spacing: 8) {
                            Text("\(milestoneVM.milestones.filter(\.isUnlocked).count) / \(milestoneVM.milestones.count)")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)

                            Text("Milestones Unlocked")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)

                            if let next = milestoneVM.nextMilestone,
                               let daysLeft = milestoneVM.daysUntilNext(currentDays: currentDays) {
                                Text("\(daysLeft) days until \(next.title)")
                                    .font(.caption)
                                    .foregroundStyle(Theme.electricBlue)
                                    .padding(.top, 4)
                            }
                        }
                        .padding(.vertical, Theme.paddingLarge)

                        // Timeline
                        ForEach(milestoneVM.milestones) { milestone in
                            MilestoneCardView(
                                milestone: milestone,
                                currentDays: currentDays
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
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
    }
}

struct CelebrationOverlay: View {
    let milestone: Milestone
    let onDismiss: () -> Void

    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var particles: [Particle] = []

    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        let color: Color
        let size: CGFloat
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .opacity(opacity)

            // Particles
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(x: particle.x, y: particle.y)
            }

            VStack(spacing: 20) {
                Image(systemName: milestone.icon)
                    .font(.system(size: 60))
                    .foregroundStyle(Theme.electricBlue)

                Text("Milestone Unlocked!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(milestone.title)
                    .font(.title2)
                    .foregroundStyle(Theme.violet)

                Text(milestone.description)
                    .font(.body)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                GlowingButton(title: "Continue", icon: "arrow.right") {
                    withAnimation {
                        onDismiss()
                    }
                }
                .padding(.top, 16)
            }
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            spawnParticles()
        }
        .onTapGesture {
            withAnimation {
                onDismiss()
            }
        }
    }

    private func spawnParticles() {
        let colors: [Color] = [Theme.electricBlue, Theme.violet, Theme.successGreen, .yellow, .white]
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        for _ in 0..<30 {
            let particle = Particle(
                x: CGFloat.random(in: 0...screenWidth),
                y: CGFloat.random(in: 0...screenHeight),
                color: colors.randomElement()!,
                size: CGFloat.random(in: 4...10)
            )
            particles.append(particle)
        }

        // Animate particles falling
        withAnimation(.easeOut(duration: 2)) {
            for i in particles.indices {
                particles[i].y += CGFloat.random(in: 100...300)
                particles[i].x += CGFloat.random(in: -50...50)
            }
        }
    }
}

#Preview {
    MilestonesView(milestoneVM: MilestoneViewModel(), currentDays: 10)
        .preferredColorScheme(.dark)
}
