import Foundation

struct Quote: Identifiable {
    let id = UUID()
    let text: String
    let author: String
}

enum Quotes {
    static let motivational: [Quote] = [
        Quote(text: "The secret of change is to focus all of your energy not on fighting the old, but on building the new.", author: "Socrates"),
        Quote(text: "Every day is a new beginning. Take a deep breath, smile, and start again.", author: "Unknown"),
        Quote(text: "You are not your habits. You are the person who can change them.", author: "James Clear"),
        Quote(text: "The pain you feel today will be the strength you feel tomorrow.", author: "Unknown"),
        Quote(text: "Fall seven times, stand up eight.", author: "Japanese Proverb"),
        Quote(text: "Your brain is rewiring itself right now. Every moment of resistance makes you stronger.", author: "Unknown"),
        Quote(text: "Freedom is what you do with what's been done to you.", author: "Jean-Paul Sartre"),
        Quote(text: "The best time to plant a tree was 20 years ago. The second best time is now.", author: "Chinese Proverb"),
        Quote(text: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius"),
        Quote(text: "Discipline is choosing between what you want now and what you want most.", author: "Abraham Lincoln"),
        Quote(text: "Boredom is the gateway to creativity. Embrace the stillness.", author: "Unknown"),
        Quote(text: "Strength does not come from winning. Your struggles develop your strengths.", author: "Arnold Schwarzenegger"),
        Quote(text: "The only person you are destined to become is the person you decide to be.", author: "Ralph Waldo Emerson"),
        Quote(text: "Your future self is watching you right now through memories. Make them proud.", author: "Unknown"),
        Quote(text: "Recovery is not a race. You don't have to feel guilty if it takes you longer than you thought.", author: "Unknown"),
        Quote(text: "What lies behind us and what lies before us are tiny matters compared to what lies within us.", author: "Ralph Waldo Emerson"),
        Quote(text: "The chains of habit are too light to be felt until they are too heavy to be broken.", author: "Warren Buffett"),
        Quote(text: "Every moment of resistance is a victory. You are literally rewiring your brain.", author: "Unknown"),
        Quote(text: "Almost everything will work again if you unplug it for a few minutes, including you.", author: "Anne Lamott"),
        Quote(text: "A year from now, you will wish you had started today.", author: "Karen Lamb"),
        Quote(text: "The mind is like water. When it's turbulent, it's difficult to see. When it's calm, everything becomes clear.", author: "Prasad Mahes"),
        Quote(text: "Attention is the rarest and purest form of generosity.", author: "Simone Weil"),
    ]

    static let brainScience: [String] = [
        "Your brain's dopamine receptors are healing right now. Each day offline allows neural pathways to normalize.",
        "Endless scrolling hijacks the brain's reward system the same way addictive substances do. Recovery is real and measurable.",
        "After just 2 weeks, your prefrontal cortex begins to regain control over impulsive behaviors and attention.",
        "Neuroplasticity means your brain can form new, healthy neural pathways at any age. It's never too late to rewire.",
        "The urge to check your phone is your brain craving a dopamine hit. It peaks and passes within 15-20 minutes.",
        "Studies show that reducing screen time leads to improved focus, deeper sleep, and better emotional regulation within weeks.",
        "Your brain fog is lifting. Dopamine sensitivity improves significantly in the first 90 days of reduced stimulation.",
        "Real human connection releases oxytocin, a far more fulfilling neurochemical than dopamine spikes from infinite feeds.",
        "Short-form content trains your brain to expect constant novelty. Recovery restores your ability to focus deeply.",
        "Your attention span isn't broken—it's been trained for distraction. Neuroplasticity lets you retrain it for focus.",
        "The default mode network, responsible for creativity and self-reflection, strengthens when you reduce digital noise.",
        "Each hour without doom scrolling allows your nervous system to downregulate from chronic overstimulation.",
    ]

    static let activitySuggestions: [(icon: String, text: String)] = [
        ("figure.walk", "Go for a walk without your phone"),
        ("phone.fill", "Call a friend or family member"),
        ("book.fill", "Read a physical book for 10 minutes"),
        ("pencil.and.outline", "Write in your journal"),
        ("cup.and.saucer.fill", "Make tea and sit in silence"),
        ("headphones", "Listen to a full album, no skipping"),
        ("figure.run", "Go for a run or exercise"),
        ("drop.fill", "Drink a glass of water mindfully"),
        ("leaf.fill", "Spend 5 minutes in nature"),
        ("hands.clap.fill", "Practice gratitude - name 3 things"),
        ("figure.mind.and.body", "Do 5 minutes of stretching"),
        ("paintbrush.fill", "Do something creative with your hands"),
    ]

    static func randomQuote() -> Quote {
        motivational.randomElement() ?? motivational[0]
    }

    static func randomBrainFact() -> String {
        brainScience.randomElement() ?? brainScience[0]
    }
}
