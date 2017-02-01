//
//  DetailsViewController.swift
//  FirstSwift
//
//  Created by BigWin on 2/1/17.
//  Copyright © 2017 BigWin. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {

    @IBOutlet var albumCover: UIImageView!
    @IBOutlet var titleLabel: UITextView!
    @IBOutlet var tracksTableView: UITableView!
    
    var album: Album?
    var tracks = [Track]()
    lazy var api : APIController = APIController(delegate: self)
    let kCellIdentifier: String = "TrackCell"
//    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    var avMediaPlayer: AVPlayerViewController = AVPlayerViewController()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = self.album?.title
        do {
            try albumCover.image = UIImage(data: Data(contentsOf: URL(string: self.album!.largeImageURL)!))
        } catch let error as NSError {
            print(error)
        }
        
        // Load in tracks
        if self.album != nil {
            api.lookupAlbum(collectionId: self.album!.collectionId)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) as! TrackCell
        let track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playIcon.text = "▶️"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]
//        mediaPlayer.stop()
//        mediaPlayer.contentURL = URL(string: track.previewUrl)
//        mediaPlayer.play()
        
        avMediaPlayer.player?.pause()
        let player = AVPlayer(url: URL(string: track.previewUrl)!)
        avMediaPlayer.player = player
        self.present(avMediaPlayer, animated: true) {
            self.avMediaPlayer.player!.play()
        }

        if let cell = tableView.cellForRow(at: indexPath) as? TrackCell {
            cell.playIcon.text = "⏸"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    // MARK: APIControllerProtocol
    func didReceiveAPIResults(results: NSArray) {
        DispatchQueue.main.async(execute: {
            self.tracks = Track.tracksWithJSON(results: results)
            self.tracksTableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
