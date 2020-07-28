import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: NSStatusBar!
    var statusBarItem: NSStatusItem!
    var statusBarMenu: NSMenu!
    var appStatus = AppStatus.initializing.rawValue

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initializeStatusBar()
        
        SongHandler.addObserver { (song, status) in
            // Destroys the SDK when AM has been inactive for over 3 minutes
            // past the song's duration and sets the status to paused
            if status == .inactive && isDiscordSDKInitialized() {
                destroyDiscordSDK()
                self.updateAppStatus(appStatus: .paused)
                return
            }

            // Sets the status to discord uninitialized when Discord
            // isn't open
            if !self.isDiscordOpen() {
                self.updateAppStatus(appStatus: .discordUninitialized)
                return
            }

            // Initializes the SDK if it is uninitialized and sets
            // the status to initializing
            if !isDiscordSDKInitialized() {
                self.updateAppStatus(appStatus: .initializing)
                initializeDiscordSDK()
            }

            
            if let s = song {
                setSong(
                    strdup(s.title),
                    strdup(s.album),
                    strdup(s.artist),
                    status == .paused
                )

                self.updateAppStatus(appStatus: .running)
            }
        }
    }
    
    func updateAppStatus(appStatus: AppStatus) {
        statusBarMenu.item(at: 0)?.title = "amcord: \(appStatus.rawValue)"
    }
    
    func isDiscordOpen() -> Bool {
        let apps = NSWorkspace.shared.runningApplications
        for app in apps {
            if app.localizedName! == "Discord" {
                return true
            }
        }
        
        return false
    }
    
    func initializeStatusBar() {
        statusBar = NSStatusBar.system
        statusBarItem = statusBar!.statusItem(
            withLength: NSStatusItem.squareLength
        )
        
        statusBarItem!.button?.title =  "♫"
        
        statusBarMenu = NSMenu(title: "amcord")
        statusBarItem!.menu = statusBarMenu
        
        statusBarMenu.addItem(
            withTitle: "amcord: \(appStatus)",
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
