import SwiftUI

struct PopoverContentView: View {
    var body: some View {
        VStack {
            DirectionalAlignmentView()
            
            Button(action: {
                NSApp.terminate(nil)
            }) {
                Text("앱 종료")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .allowsHitTesting(false)
        .frame(width: 230, height: 250)
    }
}
