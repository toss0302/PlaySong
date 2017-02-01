//
//  Album.swift
//  FirstSwift
//
//  Created by BigWin on 2/1/17.
//  Copyright © 2017 BigWin. All rights reserved.
//

import Foundation

struct Album {
    let title: String
    let price: String
    let thumbnailImageURL: String
    let largeImageURL: String
    let itemURL: String
    let artistURL: String
    let collectionId: Int
    
    init(name: String, price: String, thumbnailImageURL: String, largeImageURL: String,
        itemURL: String, artistURL: String, collectionId: Int) {
        self.title = name
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
        self.collectionId = collectionId
    }
    
    static func albumsWithJSON(results: NSArray) -> [Album] {
        // Create an empty array of aAlbums to append to from this list
        var albums = [Album]()
        
        // Store the result in our table data array
        if results.count > 0 {
            // Sometimes iTUnes returns a collection, not a track, so we check both for the 'name'
            for result in (results as? [[String:Any]])! {
                var name = result["trackName"] as? String
                if name == nil {
                    name = result["collectionName"] as? String
                }
                
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice, ..
                var price = result["formattedPrice"] as? String
                if price == nil {
                    price = result["collectionPrice"] as? String
                    if price == nil {
                        let priceFloat: Float? = result["collectionPrice"] as? Float
                        let nf: NumberFormatter = NumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$\(nf.string(from: NSNumber(value: priceFloat!)))"
                        }
                    }
                }
                let thumbnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                if let collectionId = result["collectionId"] as? Int {
                    let newAlbum = Album(name: name!,
                                         price: price!,
                                         thumbnailImageURL: thumbnailURL,
                                         largeImageURL: imageURL,
                                         itemURL: itemURL!,
                                         artistURL: artistURL,
                                         collectionId: collectionId)
                    albums.append(newAlbum)
                }
            }
        }
        return albums
    }

}
