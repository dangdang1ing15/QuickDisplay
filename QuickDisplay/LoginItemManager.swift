import ServiceManagement
import os.log

enum LoginItemManager {
    static let helperID = "ElianisBack.QuickDisplayHelper"

    static func setLoginItem(enabled: Bool) {
        do {
            let service = SMAppService.loginItem(identifier: helperID)
            if enabled {
                try service.register()
                os_log("✅ 로그인 아이템 등록됨")
            } else {
                try service.unregister()
                os_log("🚫 로그인 아이템 등록 해제됨")
            }
        } catch {
            os_log("❌ 로그인 아이템 설정 실패: %@", "\(error)")
        }
    }

    static func isLoginItemEnabled() -> Bool {
        let service = SMAppService.loginItem(identifier: helperID)
        return service.status == .enabled
    }

    static func registerIfNeeded() {
        let service = SMAppService.loginItem(identifier: helperID)
        if service.status != .enabled {
            try? service.register()
        }
    }
}
