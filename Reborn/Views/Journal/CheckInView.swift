import SwiftUI

struct CheckInView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var journalVM: JournalViewModel

    @State private var energy: Double = 5
    @State private var confidence: Double = 5
    @State private var focus: Double = 5
    @State private var mood: Double = 5
    @State private var note: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        VStack(spacing: 8) {
                            Text("How are you feeling?")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)

                            Text("Track your mental clarity and presence")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .padding(.top)

                        // Sliders
                        MoodSliderView(
                            title: "Energy",
                            icon: "bolt.fill",
                            value: $energy,
                            color: .yellow
                        )

                        MoodSliderView(
                            title: "Confidence",
                            icon: "shield.fill",
                            value: $confidence,
                            color: Theme.successGreen
                        )

                        MoodSliderView(
                            title: "Focus",
                            icon: "eye.fill",
                            value: $focus,
                            color: Theme.electricBlue
                        )

                        MoodSliderView(
                            title: "Mood",
                            icon: "face.smiling",
                            value: $mood,
                            color: Theme.violet
                        )

                        // Note
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "pencil.line")
                                    .foregroundStyle(Theme.textSecondary)
                                Text("Notes (optional)")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Theme.textPrimary)
                            }

                            TextEditor(text: $note)
                                .frame(minHeight: 100)
                                .scrollContentBackground(.hidden)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(Color.white.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
                        }
                        .padding()
                        .cardStyle()

                        // Save Button
                        GlowingButton(title: "Save Check-In", icon: "checkmark.circle.fill") {
                            journalVM.addEntry(
                                energy: Int(energy),
                                confidence: Int(confidence),
                                focus: Int(focus),
                                mood: Int(mood),
                                note: note
                            )
                            dismiss()
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Daily Check-In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
    }
}

#Preview {
    CheckInView(journalVM: JournalViewModel())
}
