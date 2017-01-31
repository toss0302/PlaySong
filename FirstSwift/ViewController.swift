//
//  ViewController.swift
//  FirstSwift
//
//  Created by BigWin on 1/24/17.
//  Copyright © 2017 BigWin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var appsTableView: UITableView!
    var tableData = [NSDictionary]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchItunesFor(searchTerm: "JQ Software")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MyTestCell")
        if self.tableData.count > indexPath.row {
            let rowData: NSDictionary = self.tableData[indexPath.row]
            
                // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            if  let urlString = rowData["artworkUrl60"] as? String,
                // Create an NSURL instance from the String URL we get from the API
                let imgURL = URL(string: urlString),
                // Get the formatted price string for display in the subtitle
                let formattedPrice = rowData["formattedPrice"] as? String,
                // Download an NSData representation of the image at the URL
                let imgData = NSData(contentsOf: imgURL as URL),
                // Get the track name
                let trackName = rowData["trackName"] as? String {
                // Get the formatted price string for display in the subtitle
                cell.detailTextLabel?.text = formattedPrice
                // Update the imageView cell to use the downloaded image data
                cell.imageView?.image = UIImage(data: imgData as Data)
                // Update the textLabel text to use the trackName from the API
                cell.textLabel?.text = trackName
            }
        }
        return cell
    }
    
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+", options: NSString.CompareOptions.caseInsensitive, range: nil)
        
        // Now escape anything else that isn't URL-friendly

        if let escapedSearchTerm = itunesSearchTerm.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            let url = URL(string: urlPath)
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
                            DispatchQueue.main.async(execute: {
                                self.tableData = results as! [NSDictionary]
                                self.appsTableView!.reloadData()
                            })
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
    }
}

