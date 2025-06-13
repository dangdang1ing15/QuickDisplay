import SwiftUI

struct DirectionalAlignmentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button(action: { align(.top) }) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable().frame(width: 40, height: 40)
            }

            HStack(spacing: 40) {
                Button(action: { align(.left) }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .resizable().frame(width: 40, height: 40)
                }

                Text("맥북 디스플레이")
                    .font(.title3)
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(12)
                    .foregroundColor(.white)

                Button(action: { align(.right) }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable().frame(width: 40, height: 40)
                }
            }

            Button(action: { align(.bottom) }) {
                Image(systemName: "arrow.down.circle.fill")
                    .resizable().frame(width: 40, height: 40)
            }
        }
    }

    private func align(_ direction: DisplayAlignmentDirection) {
        do {
            try DisplayManager.alignExternalDisplay(relativeTo: direction)
        } catch {
            print("정렬 실패: \(error)")
        }
    }
}
