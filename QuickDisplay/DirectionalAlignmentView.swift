import SwiftUI
import CoreGraphics

struct DirectionalAlignmentView: View {
    @StateObject private var monitor = ExternalDisplayMonitor()
    @State private var selectedDirection: DisplayAlignmentDirection?

    var body: some View {
        ZStack {
            if monitor.isExternalDisplayConnected {
                alignmentUI
            } else {
                VStack {
                    Spacer()
                    Text("연결된 디스플레이가 없습니다.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))
            }
        }
        .onAppear {
            if selectedDirection == nil, monitor.isExternalDisplayConnected {
                selectedDirection = detectExternalDisplayDirection()
            }
        }
        .padding()
        .frame(width: 230, height: 200)
    }

    var alignmentUI: some View {
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
    }

    func detectExternalDisplayDirection() -> DisplayAlignmentDirection? {
        var displayCount: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &displayCount)
        var displays = [CGDirectDisplayID](repeating: 0, count: Int(displayCount))
        CGGetActiveDisplayList(displayCount, &displays, nil)

        guard let main = displays.first(where: { CGDisplayIsBuiltin($0) == 1 }),
              let external = displays.first(where: { CGDisplayIsBuiltin($0) == 0 }) else {
            return nil
        }

        let mainBounds = CGDisplayBounds(main)
        let extBounds = CGDisplayBounds(external)

        let deltaX = extBounds.origin.x - mainBounds.origin.x
        let deltaY = extBounds.origin.y - mainBounds.origin.y

        if abs(deltaX) > abs(deltaY) {
            return deltaX < 0 ? .left : .right
        } else {
            return deltaY < 0 ? .top : .bottom
        }
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
                        .scaleEffect(isSelected ? 1.05 : 1.0)

                    Image(systemName: systemImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(isSelected ? .white : .gray)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }

                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(.plain)
    }
}
