//
//  AppDelegate.swift
//  QuickDisplay
//
//  Created by 성현 on 6/13/25.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "rectangle.split.3x1.fill", accessibilityDescription: "DisplayAligner")
        }

        let menu = NSMenu()

        let leftItem = NSMenuItem(title: "왼쪽으로 정렬", action: #selector(alignLeft), keyEquivalent: "")
        let rightItem = NSMenuItem(title: "오른쪽으로 정렬", action: #selector(alignRight), keyEquivalent: "")
        let topItem = NSMenuItem(title: "위쪽으로 정렬", action: #selector(alignTop), keyEquivalent: "")
        let bottomItem = NSMenuItem(title: "아래쪽으로 정렬", action: #selector(alignBottom), keyEquivalent: "")

        let settingsItem = NSMenuItem(title: "디스플레이 설정 열기", action: #selector(openDisplaySettings), keyEquivalent: "")
        let quitItem = NSMenuItem(title: "종료", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")

        menu.addItem(leftItem)
        menu.addItem(rightItem)
        menu.addItem(topItem)
        menu.addItem(bottomItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(settingsItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitItem)

        statusItem?.menu = menu
    }


    @objc func alignLeft() {
        try? DisplayManager.alignExternalDisplay(relativeTo: .left)
    }

    @objc func alignRight() {
        try? DisplayManager.alignExternalDisplay(relativeTo: .right)
    }

    @objc func alignTop() {
        try? DisplayManager.alignExternalDisplay(relativeTo: .top)
    }

    @objc func alignBottom() {
        try? DisplayManager.alignExternalDisplay(relativeTo: .bottom)
    }
    
    @objc func openDisplaySettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.displays") {
            NSWorkspace.shared.open(url)
        }
    }
}
