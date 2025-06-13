import Foundation
import CoreGraphics

final class DisplayMonitor {
    static let shared = DisplayMonitor()
    private var lastDisplayCount: UInt32 = 0
    private var windowOpener: (() -> Void)?

    func startMonitoring(openView: @escaping () -> Void) {
        self.windowOpener = openView
        updateDisplayCount()
        CGDisplayRegisterReconfigurationCallback(displayReconfigCallback, nil)
    }

    private func updateDisplayCount() {
        CGGetActiveDisplayList(0, nil, &lastDisplayCount)
    }

    private let displayReconfigCallback: CGDisplayReconfigurationCallBack = { _, _, _ in
        DispatchQueue.main.async {
            let currentCount = getDisplayCount()
            if currentCount > DisplayMonitor.shared.lastDisplayCount {
                DisplayMonitor.shared.windowOpener?()
            }
            DisplayMonitor.shared.lastDisplayCount = currentCount
        }
    }

    private static func getDisplayCount() -> UInt32 {
        var count: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &count)
        return count
    }
}
