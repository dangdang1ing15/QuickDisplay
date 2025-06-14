//
//  QuickDisplayApp.swift
//  QuickDisplay
//
//  Created by 성현 on 6/13/25.
//

import SwiftUI

@main
struct QuickDisplayApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        LoginItemManager.registerIfNeeded()
    }

    var body: some Scene {
        Settings { EmptyView() }
    }
}
