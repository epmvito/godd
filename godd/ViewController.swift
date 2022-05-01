//
//  ViewController.swift
//  DownloadTask
//
//  Created by Emmanuel Okwara on 19/12/2020.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!    
    @IBOutlet weak var progressLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.progress = 0
        
        let videoURL = URL(string: "")
                self.player = AVPlayer(url: videoURL!)
                self.playerViewController = AVPlayerViewController()
                playerViewController.player = self.player
                playerViewController.view.frame = self.playerView.frame
                playerViewController.player?.pause()
                self.playerView.addSubview(playerViewController.view)
    }
    @IBAction func downloadBtnClicked(_ sender: UIButton) {
        progressLbl.isHidden = false
        let urlString = "http://185.162.124.197:80/vteka/00/00/00/52/41.mp4?token=2-vod_cfd1cfb0d61d89e8e77c8dfd9a6b862a"
        guard let url = URL(string: urlString) else {
            print("This is an invalid URL")
            return
        }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        session.downloadTask(with: url).resume()
    }
    
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else {
            print("The data could not be loaded")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.progressLbl.isHidden = true
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        
        DispatchQueue.main.async { [weak self] in
            self?.progressBar.progress = progress
            self?.progressLbl.text = "\(progress * 100)%"
            
        }
    }
}
