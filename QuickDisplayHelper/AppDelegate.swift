import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("Helper 앱 시작됨 - 메인 앱 실행 시도")

        let helperPath = Bundle.main.bundlePath
        let mainAppPath = (helperPath as NSString).deletingLastPathComponent
        let mainAppFullPath = (mainAppPath as NSString).appendingPathComponent("QuickDisplay.app")

        print("메인 앱 경로: \(mainAppFullPath)")

        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [mainAppFullPath]
        task.launch()

        print("메인 앱 실행 명령 완료 - Helper 앱 종료")

        NSApp.terminate(nil)
    }
}
