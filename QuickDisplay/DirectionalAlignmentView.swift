import SwiftUI

struct DirectionalAlignmentView: View {
    @State private var selectedDirection: DisplayAlignmentDirection?

    var body: some View {
        VStack(spacing: 12) {
            displayThumbnail(direction: .top, systemImage: "arrow.up.circle.fill", label: "위쪽")

            HStack(spacing: 24) {
                displayThumbnail(direction: .left, systemImage: "arrow.left.circle.fill", label: "왼쪽")

                VStack(spacing: 4) {
                    Image(systemName: "laptopcomputer")
                        .resizable()
                        .frame(width: 40, height: 30)
                        .foregroundColor(.blue)
                    Text("My Mac")
                        .font(.caption)
                        .foregroundColor(.primary)
                }

                displayThumbnail(direction: .right, systemImage: "arrow.right.circle.fill", label: "오른쪽")
            }

            displayThumbnail(direction: .bottom, systemImage: "arrow.down.circle.fill", label: "아래쪽")
        }
        .padding()
        .frame(width: 280, height: 280)
    }

    @ViewBuilder
    private func displayThumbnail(direction: DisplayAlignmentDirection, systemImage: String, label: String) -> some View {
        let isSelected = selectedDirection == direction

        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                selectedDirection = direction
            }
            try? DisplayManager.alignExternalDisplay(relativeTo: direction)
        }) {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 48, height: 30)
                        .foregroundColor(isSelected ? .blue.opacity(0.7) : .gray.opacity(0.3))
                        .scaleEffect(isSelected ? 1.05 : 1.0) // ⬅️ 강조 확대 효과
                        .animation(.easeInOut(duration: 0.2), value: isSelected)

                    Image(systemName: systemImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(isSelected ? .white : .gray)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: isSelected)
                }

                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(.plain)
    }
}
