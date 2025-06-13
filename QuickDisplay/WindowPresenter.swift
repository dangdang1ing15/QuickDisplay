import SwiftUI
import AppKit

final class WindowPresenter: NSObject, NSWindowDelegate {
    static let shared = WindowPresenter()

    private var window: NSWindow?
    private var hostingController: NSHostingController<DirectionalAlignmentView>?

    func showAlignmentWindow() {
        guard window == nil else { return }

        let controller = NSHostingController(rootView: DirectionalAlignmentView())
        self.hostingController = controller

        let win = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 320),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        win.title = "디스플레이 정렬"
        win.isReleasedWhenClosed = false // 수동 해제
        win.isRestorable = false         // 복원 비활성화
        win.delegate = self
        win.contentViewController = controller

        // ✅ 정확한 내장 디스플레이 정중앙 위치 계산
        if let screen = NSScreen.screens.first(where: {
            $0.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID == CGMainDisplayID()
        }) {
            let screenFrame = screen.visibleFrame
            let windowSize = CGSize(width: 320, height: 320)

            let origin = CGPoint(
                x: screenFrame.origin.x + (screenFrame.width - windowSize.width) / 2,
                y: screenFrame.origin.y + (screenFrame.height - windowSize.height) / 2
            )

            win.setFrame(NSRect(origin: origin, size: windowSize), display: true)
        }

        self.window = win

        // ✅ 창 띄우기 전 포그라운드 활성화 필수
        NSApp.activate(ignoringOtherApps: true)
        win.makeKeyAndOrderFront(nil)
    }

    func windowWillClose(_ notification: Notification) {
        // ✅ 안전한 수동 해제
        window?.orderOut(nil)
        window?.delegate = nil
        window?.contentViewController = nil
        hostingController = nil
        window = nil
    }
}
