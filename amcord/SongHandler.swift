import Cocoa

class SongHandler {
    static var timer: Timer!
    static var currentTime = 0
    static var isPaused = false
    
    static func initialize() {
        DistributedNotificationCenter
            .default()
            .addObserver(
                self,
                selector: #selector(self.songInfoUpdated),
                name: NSNotification.Name(rawValue: "com.apple.iTunes.playerInfo"),
                object: nil
            )
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            if (!isPaused) {
                currentTime += 1
            }
        })
    }
    
    @objc static func songInfoUpdated(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let nilTest = userInfo["Artist"] == nil
            if (nilTest) {
                return
            }
            
            let artist = userInfo["Artist"] as! String
            let album = userInfo["Album"] as! String
            let name = userInfo["Name"] as! String
            isPaused = (userInfo["Player State"] as! String) == "Paused"
            
            if isPaused {
                pauseSong()
                return
            }
            
            playSong(strdup(name), strdup(album), strdup(artist))
        }
    }
}
