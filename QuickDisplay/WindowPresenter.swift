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

        win.delegate = self
        win.center()
        win.isReleasedWhenClosed = false
        win.isRestorable = false
        win.title = "디스플레이 정렬"
        win.contentViewController = controller

        self.window = win

        NSApp.activate(ignoringOtherApps: true)
        win.makeKeyAndOrderFront(nil)
    }

    func windowWillClose(_ notification: Notification) {
        window?.orderOut(nil)
        window?.delegate = nil
        window?.contentViewController = nil
        hostingController = nil
        window = nil
    }
}
