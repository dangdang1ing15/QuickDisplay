import SwiftUI
import AppKit

final class WindowPresenter: NSObject, NSWindowDelegate {
    static let shared = WindowPresenter()

    private var window: NSWindow?
    private var hostingController: NSHostingController<DirectionalAlignmentView>?

    private var panel: NSPanel?
    private var panelHostingView: NSHostingView<PopoverContentView>?

    // MARK: - 일반 윈도우 (DirectionalAlignmentView)
    func showAlignmentWindow() {
        if window != nil {
            window?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let controller = NSHostingController(rootView: DirectionalAlignmentView())
        self.hostingController = controller

        let win = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 320),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        win.title = "디스플레이 정렬"
        win.isReleasedWhenClosed = false
        win.isRestorable = false
        win.delegate = self
        win.contentViewController = controller

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

        NSApp.activate(ignoringOtherApps: true)
        win.makeKeyAndOrderFront(nil)
    }

    func windowWillClose(_ notification: Notification) {
        if let win = notification.object as? NSWindow, win == window {
            window?.orderOut(nil)
            window?.delegate = nil
            window?.contentViewController = nil
            hostingController = nil
            window = nil
        }
    }

    // MARK: - 패널 (PopoverContentView)
    func showPopoverWindow() {
        if panel != nil {
            panel?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let contentView = NSHostingView(rootView: PopoverContentView())
        self.panelHostingView = contentView

        let win = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 230, height: 250),
            styleMask: [.titled, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        win.contentView = contentView
        win.isFloatingPanel = true
        win.level = .floating
        win.hidesOnDeactivate = true
        win.delegate = self
        win.center()

        self.panel = win
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func windowDidResignKey(_ notification: Notification) {
        if let win = notification.object as? NSPanel, win == panel {
            panel?.orderOut(nil)
            panel = nil
            panelHostingView = nil
        }
    }
}
