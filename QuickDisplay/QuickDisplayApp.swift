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

        var body: some Scene {
            Settings {
                EmptyView()
            }
        }
}
