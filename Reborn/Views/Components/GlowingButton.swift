import SwiftUI

struct GlowingButton: View {
    let title: String
    let icon: String?
    let color: Color
    let action: () -> Void

    @State private var isGlowing = false

    init(title: String, icon: String? = nil, color: Color = Theme.electricBlue, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.headline)
                }
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                Capsule()
                    .fill(color.gradient)
            )
            .overlay(
                Capsule()
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: color.opacity(isGlowing ? 0.6 : 0.3), radius: isGlowing ? 20 : 10)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isGlowing = true
            }
        }
    }
}

#Preview {
    ZStack {
        GradientBackground()
        VStack(spacing: 20) {
            GlowingButton(title: "Start Journey", icon: "play.fill") {}
            GlowingButton(title: "SOS", icon: "exclamationmark.triangle.fill", color: Theme.warningRed) {}
        }
    }
}
