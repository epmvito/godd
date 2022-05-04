//
//  DownloadViewController.swift
//  godd
//
//  Created by мак on 03.05.2022.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController{
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLbl: UILabel!
    
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let downloadService = DownloadService()
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    
    @IBAction func download(_ sender: Any) {
       
        let movie = Movie(url: URL(string: "http://185.162.124.197:80/vteka/00/00/00/52/55.mp4?token=2-vod_28ac203ba05a159784c2cc15de467111")!)
        downloadService.startDownload(movie)
    }
    
    @IBAction func pause(_ sender: Any) {
        let movie = Movie(url: URL(string: "http://185.162.124.197:80/vteka/00/00/00/52/55.mp4?token=2-vod_28ac203ba05a159784c2cc15de467111")!)
        downloadService.pauseDownload(movie)
    }
    
    @IBAction func cancel(_ sender: Any) {
        let movie = Movie(url: URL(string: "http://185.162.124.197:80/vteka/00/00/00/52/55.mp4?token=2-vod_28ac203ba05a159784c2cc15de467111")!)
        downloadService.cancelDownload(movie)
    }
    
    @IBAction func resume(_ sender: Any) {
        let movie = Movie(url: URL(string: "http://185.162.124.197:80/vteka/00/00/00/52/55.mp4?token=2-vod_28ac203ba05a159784c2cc15de467111")!)
        downloadService.resumeDownload(movie)
    }
    
    @IBAction func play(_ sender: Any) {
        let movie = Movie(url: URL(string: "http://185.162.124.197:80/vteka/00/00/00/52/55.mp4?token=2-vod_28ac203ba05a159784c2cc15de467111")!)
        playDownload(movie)
    }
    
    
    func localFilePath(for url: URL) -> URL {
      return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    func playDownload(_ movie: Movie) {
      let playerViewController = AVPlayerViewController()
      present(playerViewController, animated: true, completion: nil)
      
      let url = localFilePath(for: movie.url)
      let player = AVPlayer(url: url)
      playerViewController.player = player
      player.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadService.downloadsSession = downloadsSession
    }
}


extension ViewController: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                  didFinishDownloadingTo location: URL) {
    // 1
    guard let sourceURL = downloadTask.originalRequest?.url else {
      return
    }
    
    let download = downloadService.activeDownloads[sourceURL]
    downloadService.activeDownloads[sourceURL] = nil
    
    // 2
    let destinationURL = localFilePath(for: sourceURL)
    print(destinationURL)
    
    // 3
    let fileManager = FileManager.default
    try? fileManager.removeItem(at: destinationURL)
    
    do {
      try fileManager.copyItem(at: location, to: destinationURL)
      download?.movie.downloaded = true
    } catch let error {
      print("Could not copy file to disk: \(error.localizedDescription)")
    }
    
    // 4
//    if let index = download?.movie.index {
//      DispatchQueue.main.async { [weak self] in
//        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
//      }
//    }
  }
  
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else {
                // Handle success case.
                return
            }
            let userInfo = (error as NSError).userInfo
            if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
//                self.resumeData = resumeData
                guard let url = task.originalRequest?.url else{
                    return
                }
                self.downloadService.activeDownloads[url]?.resumeData = resumeData
            }
    }
    
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                  didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                  totalBytesExpectedToWrite: Int64) {
    // 1
    guard
      let url = downloadTask.originalRequest?.url,
      let download = downloadService.activeDownloads[url]  else {
        return
    }
    
    // 2
    download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    // 3
    let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
    
      
    let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    DispatchQueue.main.async { [weak self] in
          self?.progressBar.progress = progress
          self?.progressLbl.text = "\(progress * 100)%"
      }

//    // 4
//    DispatchQueue.main.async {
//      if let trackCell = self.tableView.cellForRow(at: IndexPath(row: download.track.index,
//                                                                 section: 0)) as? TrackCell {
//        trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
//      }
//    }
  }
}
