import Cocoa

class Alternative: NSApplication {
    let strongDelegate = AppDelegate()

    override init() {
        super.init()
        self.delegate = strongDelegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


@main
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
  var window: NSWindow!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    window = NSWindow(
      contentRect: NSMakeRect(0, 0, 600, 500),
      styleMask: [.titled, .resizable, .closable, .miniaturizable],
      backing: .buffered,
      defer: false
    )
    window.title = "Alternative"
    window.makeKeyAndOrderFront(nil)
    window.delegate = self

    window.contentView = MetalLayerView(frame: NSRect(origin: CGPoint.zero, size: window.frame.size))
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
