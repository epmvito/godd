//import UIKit
//import AVKit
//
//class VideoDownloadViewController: UIViewController {
//
//    private var player:AVPlayer?
//    private var playerLayer:AVPlayerLayer?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        print(NSHomeDirectory())
//    }
//
//    @IBAction func download() {
//
//        let videoUrl = "http://7xp99e.com2.z0.glb.qiniucdn.com/2/video_article/6351A5E8_7F6C_4717_B91D_FE750634B5D5.mp4"
//
//        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
//        let destPath = NSString(string: documentPath).appendingPathComponent("video.mp4") as String
//
//        if FileManager.default.fileExists(atPath: destPath) {
//            print("file already exist at \(destPath)")
//            self.playVideo(localPath: NSURL(fileURLWithPath: destPath))
//            return
//        }
////        (NSURL(string: videoUrl)! as URL)
//        NSURLSession.sharedSession.downloadTaskWithURL(NSURL(string: videoUrl) as URL) {
//            (location:NSURL?, response:NSURLResponse?, err:NSError?) -> Void in
//            if let _ = location {
//                do {
//                    try NSFileManager.defaultManager().moveItemAtURL(location!, toURL: NSURL(fileURLWithPath: destPath))
//                    self.playVideo(NSURL(fileURLWithPath: destPath))
//                }
//                catch let error as NSError {
//                    print("move file error: \(error.localizedDescription)")
//                }
//            } else {
//                print("location err: \(location)")
//            }
//        }.resume()
//    }
//
//    private func playVideo(localPath:NSURL) {
//
//        self.player = AVPlayer(url: localPath as URL)
//
//        self.playerLayer = AVPlayerLayer(player: self.player)
//        self.playerLayer?.frame = self.view.frame
//        self.view.layer.addSublayer(self.playerLayer!)
//        self.player?.play()
//    }
//}
//// to support the http,open info.plist,add `App Transport Security Settings` then add `Allow Arbitrary Loads` item and set value `YES`
