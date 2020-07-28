import Foundation

public class Song {
    var title: String!
    var artist: String!
    var album: String!
    
    init(_ title: String, _ artist: String, _ album: String) {
        self.title = title
        self.artist = artist
        self.album = album
    }
}
