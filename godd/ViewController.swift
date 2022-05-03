//
// wfawfawfftdrxctfvygbhgv

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    var videoUrl: URL?
    var resumeData: Data?
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!    
    @IBOutlet weak var progressLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.progress = 0
        
        
//        let videoURL = URL(string: "http://185.162.124.197:80/vteka/00/00/00/52/41.mp4?token=2-vod_cfd1cfb0d61d89e8e77c8dfd9a6b862a")
//                self.player = AVPlayer(url: videoURL!)
//                self.playerViewController = AVPlayerViewController()
//                playerViewController.player = self.player
//                playerViewController.view.frame = self.playerView.frame
//                playerViewController.player?.pause()
//                self.playerView.addSubview(playerViewController.view)
    }
    
 
    @IBAction func openBtnClicked(_ sender: Any) {
        
        self.player = AVPlayer(url: self.videoUrl!)
        self.playerViewController = AVPlayerViewController()
        playerViewController.player = self.player
        playerViewController.view.frame = self.playerView.frame
        playerViewController.player?.pause()
        self.playerView.addSubview(playerViewController.view)
        
    }
    
    
    @IBAction func downloadBtnClicked(_ sender: UIButton) {
        progressLbl.isHidden = false
        let urlString = "http://144.217.6.186:80/CH71_std/archive-1651514400-2820.mp4?token=1-5f8fbadf1c8e144efc1876a677de8ea1"
//        let urlString = "http://185.162.124.197:80/vteka/00/00/00/79/85.mp4?token=2-vod_77f1469134287db82fa36f07151d943c"
//        let urlString = "http://185.162.124.197:80/vteka/00/00/00/32/37.mp4?token=2-vod_0d1021c7ae360346bd94fa6dc023d8be"
//        let urlString = "http://185.162.124.197:80/vteka/00/00/00/32/39.mp4?token=2-vod_d32a1774e60b4a4f84a65939d89beef9"
//        let urlString = "https://www.tutorialspoint.com//swift/swift_tutorial.pdf"
//        let urlString = "https://download.samplelib.com/mp4/sample-20s.mp4"

        guard let url = URL(string: urlString) else {
            print("This is an invalid URL")
            return
        }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        session.downloadTask(with: url).resume()
//
        
//        let downloadTask = URLSession.shared.downloadTask(with: url) {
//            urlOrNil, responseOrNil, errorOrNil in
//            guard let fileURL = urlOrNil else { return }
//            do {
//                let documentsURL = try
//                    FileManager.default.url(for: .documentDirectory,
//                                            in: .userDomainMask,
//                                            appropriateFor: nil,
//                                            create: false)
//                let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
//                try FileManager.default.moveItem(at: fileURL, to: savedURL)
//            } catch {
//                print ("file error: \(error)")
//            }
//        }
//        downloadTask.resume()
       
            }
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File Downloaded Location: \(location)")
//        do {
//                let documentsURL = try
//                    FileManager.default.url(for: .documentDirectory,
//                                            in: .userDomainMask,
//                                            appropriateFor: nil,
//                                            create: false)
//                let savedURL = documentsURL.appendingPathComponent(
//                    location.lastPathComponent)
//                try FileManager.default.moveItem(at: location, to: savedURL)
//                self.videoUrl = savedURL
//            print("File Local Location:", self.videoUrl ?? "NO")
//            } catch {
//                // handle filesystem error
//            }
        
        guard let url = downloadTask.originalRequest?.url else{
            return
        }
        let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationPath = docsPath.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: destinationPath)
        
        do{
            try FileManager.default.copyItem(at: location, to: destinationPath)
            self.videoUrl = destinationPath
            print("File Local Location:", self.videoUrl ?? "NO")

        }
        catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async { [weak self] in
            self?.progressBar.progress = progress
            self?.progressLbl.text = "\(progress * 100)%"
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else {
                // Handle success case.
                return
            }
            let userInfo = (error as NSError).userInfo
            if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
                self.resumeData = resumeData
            }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
        
    }
}
