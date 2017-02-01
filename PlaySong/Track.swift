//
//  Track.swift
//  FirstSwift
//
//  Created by BigWin on 2/1/17.
//  Copyright © 2017 BigWin. All rights reserved.
//

import Foundation

struct Track {
    let title: String
    let price: String
    let previewUrl: String
    
    init(title: String, price: String, previewUrl: String) {
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
    
    static func tracksWithJSON(results: NSArray) -> [Track] {
        var tracks = [Track]()
        for trackInfo in (results as? [[String:Any]])! {
            // Create the track
            if let kind = trackInfo["kind"] as? String {
                if kind=="song" {
                    var trackPrice = trackInfo["trackPrice"] as? String
                    var trackTitle = trackInfo["trackName"] as? String
                    var trackPreviewUrl = trackInfo["previewUrl"] as? String
                    if(trackTitle == nil) {
                        trackTitle = "Unknown"
                    }
                    else if(trackPrice == nil) {
                        print("No trackPrice in \(trackInfo)")
                        trackPrice = "?"
                    }
                    else if(trackPreviewUrl == nil) {
                        trackPreviewUrl = ""
                    }
                    let track = Track(title: trackTitle!, price: trackPrice!, previewUrl: trackPreviewUrl!)
                    tracks.append(track)
                }
            }
        }
        return tracks
    }
}
