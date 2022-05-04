//
//  DownloadService.swift
//  godd
//
//  Created by мак on 03.05.2022.
//

import Foundation

class DownloadService {
 
  var activeDownloads: [URL: Download] = [ : ]
  
  var downloadsSession: URLSession!
  
  func cancelDownload(_ movie: Movie) {
    guard let download = activeDownloads[movie.url] else {
      return
    }
    download.task?.cancel()

    activeDownloads[movie.url] = nil
  }
  
  func pauseDownload(_ movie: Movie) {
    guard
      let download = activeDownloads[movie.url],
      download.isDownloading
      else {
        return
    }
    
    download.task?.cancel(byProducingResumeData: { data in
      download.resumeData = data
    })

    download.isDownloading = false
  }
  
  func resumeDownload(_ movie: Movie) {
    guard let download = activeDownloads[movie.url] else {
      return
    }
    
    if let resumeData = download.resumeData {
      download.task = downloadsSession.downloadTask(withResumeData: resumeData)
    } else {
      download.task = downloadsSession.downloadTask(with: download.movie.url)
    }
    
    download.task?.resume()
    download.isDownloading = true
  }
  
  func startDownload(_ movie: Movie) {

      let download = Download(movie: movie)

      download.task = downloadsSession.downloadTask(with: movie.url)
    
      download.task?.resume()

      download.isDownloading = true
      
      activeDownloads[download.movie.url] = download
  }
}
