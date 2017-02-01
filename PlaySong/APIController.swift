//
//  APIController.swift
//  FirstSwift
//
//  Created by BigWin on 1/31/17.
//  Copyright © 2017 BigWin. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
}

class APIController {

    var delegate: APIControllerProtocol
    
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    
    func get(path: String) {
        let url = URL(string: path)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {(data, response, error) -> Void in
            print("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                print(error!.localizedDescription)
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let results = jsonResult["results"] {
                        self.delegate.didReceiveAPIResults(results: results as! NSArray)
                    }
                }
            } catch let error as NSError {
                print(error)
            }
            
        })
        
        // The task is just an object with all these properties set
        // In order to actually make the web request, we need to "resume"
        task.resume()
    }

    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+", options: NSString.CompareOptions.caseInsensitive, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        
        if let escapedSearchTerm = itunesSearchTerm.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            get(path: urlPath)
        }
    }

    func lookupAlbum(collectionId: Int) {
        get(path: "https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }
}
