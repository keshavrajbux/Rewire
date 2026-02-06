import SwiftUI

struct GradientBackground: View {
    var body: some View {
        Theme.backgroundGradient
            .ignoresSafeArea()
    }
}

#Preview {
    GradientBackground()
}
