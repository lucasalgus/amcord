import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: NSStatusBar!
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        SongHandler.initialize()
        initializeDiscordSDK()
        initializeStatusBar()
    }
    
    func initializeStatusBar() {
        statusBar = NSStatusBar.system
        statusBarItem = statusBar!.statusItem(
            withLength: NSStatusItem.squareLength
        )
        
        statusBarItem!.button?.title =  "♫"
        
        let statusBarMenu = NSMenu(title: "amcord")
        statusBarItem!.menu = statusBarMenu
        
        statusBarMenu.addItem(
                withTitle: "amcord: Running",
                action: nil,
                keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "Quit",
            action: #selector(quit),
            keyEquivalent: "")
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
}

