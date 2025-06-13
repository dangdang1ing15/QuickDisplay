import Foundation
import CoreGraphics

enum DisplayAlignmentDirection {
    case left
    case right
    case top
    case bottom
}

struct DisplayManager {
    static func alignExternalDisplay(relativeTo direction: DisplayAlignmentDirection) throws {
        var displayCount: UInt32 = 0
        guard CGGetActiveDisplayList(0, nil, &displayCount) == .success,
              displayCount >= 2 else {
            throw NSError(domain: "DisplayError", code: 1, userInfo: [NSLocalizedDescriptionKey: "디스플레이가 2개 이상 연결되어 있어야 합니다."])
        }

        var displays = [CGDirectDisplayID](repeating: 0, count: Int(displayCount))
        CGGetActiveDisplayList(displayCount, &displays, nil)

        guard let mainDisplay = displays.first(where: { CGDisplayIsBuiltin($0) == 1 }),
              let externalDisplay = displays.first(where: { CGDisplayIsBuiltin($0) == 0 }) else {
            throw NSError(domain: "DisplayError", code: 2, userInfo: [NSLocalizedDescriptionKey: "내장 및 외장 디스플레이를 식별할 수 없습니다."])
        }

        let mainBounds = CGDisplayBounds(mainDisplay)
        let extBounds = CGDisplayBounds(externalDisplay)

        var targetOrigin = CGPoint.zero

        switch direction {
        case .left:
            targetOrigin = CGPoint(x: Int(mainBounds.origin.x) - Int(extBounds.width), y: Int(mainBounds.origin.y))
        case .right:
            targetOrigin = CGPoint(x: Int(mainBounds.origin.x) + Int(mainBounds.width), y: Int(mainBounds.origin.y))
        case .top:
            targetOrigin = CGPoint(
                x: mainBounds.origin.x,
                y: mainBounds.origin.y - extBounds.height
            )
        case .bottom:
            targetOrigin = CGPoint(
                x: Int(mainBounds.origin.x),
                y: Int(mainBounds.origin.y) + Int(mainBounds.height)
            )
        }

        var config: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&config)
        CGConfigureDisplayOrigin(config, externalDisplay, Int32(targetOrigin.x), Int32(targetOrigin.y))
        CGCompleteDisplayConfiguration(config, .permanently)
    }
}
