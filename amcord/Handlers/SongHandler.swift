import Cocoa

class SongHandler {
    static var songChangedCallback: ((Song?, SongStatus) -> Void)!
    static var timer: Timer!
    static var songTime = 0
    static var songDuration: Int?
    static var isPaused = false
    
    static func addObserver(callback: @escaping (Song?, SongStatus) -> Void) {
        songChangedCallback = callback
        
        DistributedNotificationCenter
            .default()
            .addObserver(
                self,
                selector: #selector(self.songInfoUpdated),
                name: NSNotification.Name(rawValue: "com.apple.iTunes.playerInfo"),
                object: nil
            )
        
        timer =
            Timer
                .scheduledTimer(
                    withTimeInterval: 1.0,
                    repeats: true,
                    block: self.timerHandler
            )
        
        songChangedCallback(nil, .inactive)
    }
    
    static func timerHandler(_: Timer) {
        if let duration = songDuration {
            songTime += 1
            
            if songTime == duration {
                songChangedCallback(nil, .inactive)
            }
        }
    }
    
    @objc static func songInfoUpdated(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let nilTest = userInfo["Artist"] == nil
            if nilTest {
                return
            }
            
            let title = userInfo["Name"] as! String
            let artist = userInfo["Artist"] as! String
            let album = userInfo["Album"] as! String
            let duration = userInfo["Total Time"] as! Int
            
            let song = Song(title, artist, album)
            
            self.songDuration = duration
            
            isPaused = (userInfo["Player State"] as! String) == "Paused"
            
            if isPaused {
                songChangedCallback(song, .paused)
            } else {
                songTime = 0
                songChangedCallback(song, .playing)
            }
        }
    }
}
