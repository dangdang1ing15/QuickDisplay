import Cocoa
import SwiftUI
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // 🔥 로그: 진입 확인
        print("🔥 AppDelegate.applicationDidFinishLaunching 진입")

        // ✅ 사용자에게 최초 1회만 자동 실행 여부 묻기
        handleLaunchAtLoginConsentIfNeeded()

        // ✅ 메뉴바 아이템 생성
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "display.2", accessibilityDescription: "Display Manager")
            button.action = #selector(togglePopover(_:))
            button.target = self
        }

        // ✅ 팝오버 구성
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 230, height: 300)
        popover?.behavior = .transient
        popover?.animates = true
        popover?.delegate = self
        popover?.contentViewController = NSHostingController(rootView: PopoverContentView())

        // ✅ 외장 디스플레이 모니터링 등 부가 기능 실행
        DisplayMonitor.shared.startMonitoring(openView: {
            DispatchQueue.main.async {
                WindowPresenter.shared.showAlignmentWindow()
            }
        })

        // 앱 전면 활성화
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    /// 최초 실행 시 자동 실행 여부 묻기
    private func handleLaunchAtLoginConsentIfNeeded() {
        let defaults = UserDefaults.standard

        // 이미 물어본 적이 있다면 스킵
        if defaults.bool(forKey: "hasAskedLaunchAtLogin") {
            print("🔁 이미 물어봤으므로 건너뜀")
            return
        }

        // ✅ 앱을 명시적으로 전면 활성화 (Alert가 보이게)
        NSApp.activate(ignoringOtherApps: true)

        // ✅ 팝업 생성
        let alert = NSAlert()
        alert.messageText = "앱을 로그인 시 자동 실행할까요?"
        alert.informativeText = "이 설정은 나중에 앱에서 변경할 수 있습니다."
        alert.addButton(withTitle: "허용")
        alert.addButton(withTitle: "허용 안 함")

        let response = alert.runModal()
        let shouldEnable = (response == .alertFirstButtonReturn)

        // ✅ 상태 저장
        defaults.set(true, forKey: "hasAskedLaunchAtLogin")
        defaults.set(shouldEnable, forKey: "launchAtLoginEnabled")

        if shouldEnable {
            do {
                try SMAppService.mainApp.register()
                print("✅ 메인 앱 자동 실행 등록 완료")
            } catch {
                print("❌ 자동 실행 등록 실패: \(error)")
            }
        } else {
            print("🚫 사용자가 자동 실행을 원하지 않음")
        }
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
