import Cocoa
import SwiftUI
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        // ✅ 최초 실행 시 자동 실행 여부 묻기
        if !UserDefaults.standard.bool(forKey: "hasAskedLaunchAtLogin") {
            askLaunchAtLoginConsent()
        }

        // 메뉴바 아이템 생성
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "display.2", accessibilityDescription: "Display Manager")
            button.action = #selector(togglePopover(_:))
            button.target = self
        }

        // 팝오버 설정
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 100, height: 100)
        popover?.behavior = .transient
        popover?.animates = true
        popover?.delegate = self
        popover?.contentViewController = NSHostingController(rootView: PopoverContentView())

        // 외장 디스플레이 감지 시작
        DisplayMonitor.shared.startMonitoring(openView: {
            DispatchQueue.main.async {
                WindowPresenter.shared.showAlignmentWindow()
            }
        })

        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    /// 사용자에게 자동 실행 여부 묻기
    func askLaunchAtLoginConsent() {
        let alert = NSAlert()
        alert.messageText = "앱을 로그인 시 자동으로 실행할까요?"
        alert.informativeText = "이 설정은 나중에 변경할 수 있습니다."
        alert.addButton(withTitle: "허용")
        alert.addButton(withTitle: "허용 안 함")

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            do {
                let loginItem = try SMAppService.loginItem(identifier: "com.elianisback.QuickDisplayHelper") // ✅ 헬퍼 번들 ID 확인
                try loginItem.register()
                print("✅ 로그인 아이템 등록 완료")
            } catch {
                print("❌ 로그인 아이템 등록 실패: \(error)")
            }
        }

        UserDefaults.standard.set(true, forKey: "hasAskedLaunchAtLogin")
    }

    @objc func togglePopover(_ sender: Any?) {
        guard let button = statusItem?.button, let popover = popover else { return }
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    func popoverShouldClose(_ popover: NSPopover) -> Bool {
        return true
    }
}
