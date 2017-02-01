//
//  ViewController.swift
//  FirstSwift
//
//  Created by BigWin on 1/24/17.
//  Copyright © 2017 BigWin. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {

    var api : APIController!
    var tableData = [NSDictionary]()
    var imageCache = [String:UIImage]()
    var albums = [Album]()

    @IBOutlet var appsTableView: UITableView!
    let kCellIdentifier: String = "SearchResultCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        api.searchItunesFor(searchTerm: "Beatles")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MyTestCell")
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)!
        if self.albums.count > indexPath.row {
            let album = self.albums[indexPath.row]
            
            // Get the formatted price string for display in the subtitle
            cell.detailTextLabel?.text = album.price
            // Update the textLabel text to use the trackName from the API
            cell.textLabel?.text = album.title
            
            // Start by setting the cell's image to a static file
            // Without this, we will end up without an image view!
            cell.imageView?.image = UIImage(named: "Blank52")
            
            let thumbnailURLString = album.thumbnailImageURL
            let thumbnailURL = URL(string: thumbnailURLString)!
            
            // If this image is already cached, don't re-download
            if let img = imageCache[thumbnailURLString] {
                cell.imageView?.image = img
            }
            else {
                // The image isn't cached, download the img data
                // We should perform this in a background thread
                let request: URLRequest = URLRequest(url: thumbnailURL)
                let session  = URLSession.shared
                
                let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
                    
                    if error == nil {
                        // Convert the downloaded data in to a UIImage object
                        let image = UIImage(data: data!)
                        // Store the image in to our cache
                        self.imageCache[thumbnailURLString] = image
                        // Update the cell
                        DispatchQueue.main.async(execute: {
                            if let cellToUpdate = tableView.cellForRow(at: indexPath) {
                                cellToUpdate.imageView?.image = image
                            }
                        })
                    }
                    else {
                        print("Error: \(error?.localizedDescription)")
                    }
                    
                })
                task.resume()
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Get the row data for the selected row
//        if self.tableData.count > indexPath.row {
//            let rowData: NSDictionary = self.tableData[indexPath.row]
//            // Get the name of the track for this row
//            if let name = rowData["trackName"] as? String,
//                // Get the price of the track on this row
//                let formattedPrice = rowData["formattedPrice"] as? String {
//                
//                let alert = UIAlertController(title: name, message: formattedPrice, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
//    }
    
    func didReceiveAPIResults(results: NSArray) {
        DispatchQueue.main.async(execute: {
            self.albums = Album.albumsWithJSON(results: results)
            self.appsTableView!.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsViewController: DetailsViewController = segue.destination as? DetailsViewController {
            let albumIndex = appsTableView!.indexPathForSelectedRow!.row
            let selectedAlbum = self.albums[albumIndex]
            detailsViewController.album = selectedAlbum
        }
    }
}

