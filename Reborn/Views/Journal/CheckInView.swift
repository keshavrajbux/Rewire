import SwiftUI

struct CheckInView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var journalVM: JournalViewModel

    @State private var energy: Double = 5
    @State private var confidence: Double = 5
    @State private var focus: Double = 5
    @State private var mood: Double = 5
    @State private var note: String = ""
    @State private var isSaving = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    LazyVStack(spacing: Theme.paddingMedium) {
                        // Header
                        VStack(spacing: 8) {
                            Text("How are you feeling?")
                                .font(Theme.Typography.title)
                                .foregroundStyle(Theme.textPrimary)

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
                            color: Theme.gold
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
                            color: Theme.neonBlue
                        )

                        MoodSliderView(
                            title: "Mood",
                            icon: "heart.fill",
                            value: $mood,
                            color: Theme.royalViolet
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
                                .foregroundStyle(Theme.textPrimary)
                                .padding(12)
                                .background(Theme.textPrimary.opacity(0.03))
                                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.cornerRadiusSmall)
                                        .stroke(Theme.textPrimary.opacity(0.1), lineWidth: 1)
                                )
                        }
                        .padding()
                        .cardStyle()

                        // Save Button
                        GlowingButton(
                            title: isSaving ? "Saving..." : "Save Check-In",
                            icon: isSaving ? nil : "checkmark.circle.fill"
                        ) {
                            saveEntry()
                        }
                        .disabled(isSaving)
                        .padding(.top, 8)
                        .padding(.bottom, 60)
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
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func saveEntry() {
        isSaving = true

        Task {
            do {
                try await journalVM.addEntry(
                    energy: Int(energy),
                    confidence: Int(confidence),
                    focus: Int(focus),
                    mood: Int(mood),
                    note: note.isEmpty ? nil : note
                )

                // Haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()

                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                isSaving = false
            }
        }
    }
}

#Preview {
    CheckInView(journalVM: JournalViewModel())
}
