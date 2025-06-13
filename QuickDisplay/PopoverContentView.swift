import SwiftUI

struct PopoverContentView: View {
    var body: some View {
        VStack {
            DirectionalAlignmentView()
            
            AutoLaunchToggleView()
            
            Button(action: {
                NSApp.terminate(nil)
            }) {
                Text("앱 종료")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .frame(width: 230, height: 300)
    }
}

struct AutoLaunchToggleView: View {
    @State private var autoLaunchEnabled = false

    var body: some View {
        Toggle("자동 실행", isOn: $autoLaunchEnabled)
            .onChange(of: autoLaunchEnabled) { newValue in
                LoginItemManager.setLoginItem(enabled: newValue)
            }
            .padding()
            .onAppear {}
    }
}

