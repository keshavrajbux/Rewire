import Foundation

struct Milestone: Identifiable {
    let id = UUID()
    let days: Int
    let title: String
    let description: String
    let scienceFact: String
    let icon: String

    var isUnlocked: Bool = false

    static let all: [Milestone] = [
        Milestone(
            days: 1,
            title: "First Step",
            description: "You've completed your first day. The journey to reclaim your mind begins.",
            scienceFact: "Your brain has already started to notice the change. Dopamine levels begin adjusting within hours of reduced stimulation.",
            icon: "sunrise.fill"
        ),
        Milestone(
            days: 3,
            title: "Breaking the Loop",
            description: "Three days strong. The automatic reach for your phone is weakening.",
            scienceFact: "The acute craving response is peaking. After this, the urge to scroll typically begins to lessen in intensity.",
            icon: "flame.fill"
        ),
        Milestone(
            days: 7,
            title: "One Week Warrior",
            description: "A full week! Your attention span is already starting to recover.",
            scienceFact: "After 7 days, your brain begins reducing deltaFosB proteins associated with compulsive behavior patterns.",
            icon: "star.fill"
        ),
        Milestone(
            days: 14,
            title: "Focus Restored",
            description: "Two weeks of presence. Real cognitive changes are happening.",
            scienceFact: "Dopamine receptors are healing. Many people report improved focus, better sleep, and mental clarity around this time.",
            icon: "brain.head.profile"
        ),
        Milestone(
            days: 30,
            title: "One Month Legend",
            description: "30 days! You've broken the doom scroll cycle.",
            scienceFact: "Significant neural rewiring has occurred. The prefrontal cortex is regaining executive control over impulse centers.",
            icon: "trophy.fill"
        ),
        Milestone(
            days: 60,
            title: "Deep Work Unlocked",
            description: "60 days of reclaiming your attention and creativity.",
            scienceFact: "New neural pathways are well-established. Your ability to sustain deep focus is dramatically improved.",
            icon: "bolt.shield.fill"
        ),
        Milestone(
            days: 90,
            title: "Neuroplasticity Complete",
            description: "The iconic 90-day milestone. Your brain is fundamentally rewired.",
            scienceFact: "Studies suggest 90 days is a critical threshold for neuroplastic changes. Your default mode network has strengthened significantly.",
            icon: "sparkles"
        ),
        Milestone(
            days: 180,
            title: "Half Year Hero",
            description: "Six months of mental freedom. This is who you are now.",
            scienceFact: "Your brain's stress response and emotional regulation systems have normalized. Anxiety and restlessness have significantly decreased.",
            icon: "crown.fill"
        ),
        Milestone(
            days: 365,
            title: "Mind Reclaimed",
            description: "365 days. A full year of living with intention and presence.",
            scienceFact: "Complete neurological remodeling. Your brain has fully adapted to healthy attention patterns. You've reclaimed your mind.",
            icon: "sun.max.fill"
        ),
    ]
}
