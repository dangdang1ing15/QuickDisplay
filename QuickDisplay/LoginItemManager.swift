import ServiceManagement
import os.log

enum LoginItemManager {
    static func setLoginItem(enabled: Bool) {
        guard #available(macOS 13.0, *) else { return }

        do {
            let service = SMAppService.mainApp
            if enabled {
                try service.register()
                os_log("✅ 메인 앱이 로그인 항목으로 등록됨")
            } else {
                try service.unregister()
                os_log("🚫 메인 앱이 로그인 항목에서 제거됨")
            }
        } catch {
            os_log("❌ 로그인 항목 설정 실패: %@", "\(error)")
        }
    }

    static func isLoginItemEnabled() -> Bool {
        guard #available(macOS 13.0, *) else { return false }
        return SMAppService.mainApp.status == .enabled
    }
}
