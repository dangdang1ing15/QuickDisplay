import SwiftUI
import ServiceManagement

struct PopoverContentView: View {
    @State private var autoLaunchEnabled: Bool = UserDefaults.standard.bool(forKey: "launchAtLoginEnabled")

    var body: some View {
        VStack(spacing: 16) {
            DirectionalAlignmentView()
                .frame(maxHeight: .infinity) // 상단 디스플레이 메시지를 위쪽에 고정

            Divider()
                .padding(.horizontal)

            VStack(spacing: 12) {
                Toggle("자동 실행", isOn: $autoLaunchEnabled)
                    .toggleStyle(.checkbox)
                    .onChange(of: autoLaunchEnabled) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "launchAtLoginEnabled")
                        do {
                            if newValue {
                                try SMAppService.mainApp.register()
                                print("✅ 수동 등록 성공")
                            } else {
                                try SMAppService.mainApp.unregister()
                                print("✅ 수동 해제 성공")
                            }
                        } catch {
                            print("🚫 자동 실행 변경 실패: \(error)")
                        }
                    }

                Button("앱 종료") {
                    NSApp.terminate(nil)
                }
                .foregroundColor(.red)
            }
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 16)
        .frame(width: 230, height: 300)
    }
}
