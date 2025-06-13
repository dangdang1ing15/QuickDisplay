import Foundation
import CoreGraphics

final class ExternalDisplayMonitor: ObservableObject {
    @Published var isExternalDisplayConnected: Bool = false

    init() {
        checkNow()
        startMonitoring()
    }

    private func checkNow() {
        isExternalDisplayConnected = Self.checkConnection()
    }

    private static func checkConnection() -> Bool {
        var count: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &count)
        var displays = [CGDirectDisplayID](repeating: 0, count: Int(count))
        CGGetActiveDisplayList(count, &displays, nil)
        return displays.contains(where: { CGDisplayIsBuiltin($0) == 0 })
    }

    private func startMonitoring() {
        // self를 UnsafeMutableRawPointer로 전달
        CGDisplayRegisterReconfigurationCallback(Self.displayReconfigCallback, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
    }

    // C 함수 포인터에 맞게 static 함수로 구현
    private static let displayReconfigCallback: CGDisplayReconfigurationCallBack = { display, flags, userInfo in
        // userInfo는 UnsafeMutableRawPointer로 받음
        let monitor = Unmanaged<ExternalDisplayMonitor>.fromOpaque(userInfo!).takeUnretainedValue()

        DispatchQueue.main.async {
            monitor.isExternalDisplayConnected = checkConnection()
        }
    }
}
