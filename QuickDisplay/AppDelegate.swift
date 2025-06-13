import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        // 메뉴바 아이템 생성
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "display", accessibilityDescription: "Display Manager")
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

        statusItem?.menu = nil

        // 외장 디스플레이 연결 감지 시작
        DisplayMonitor.shared.startMonitoring(openView: {
            DispatchQueue.main.async {
                WindowPresenter.shared.showAlignmentWindow()
            }
        })
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

    // 팝오버 닫힘 허용
    func popoverShouldClose(_ popover: NSPopover) -> Bool {
        return true
    }
}
