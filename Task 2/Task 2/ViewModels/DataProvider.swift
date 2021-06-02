//
//  DataProvider.swift
//  Task 2
//
//  Created by piro on 19.05.21.
//

import UIKit

class DataProvider: NSObject {
    
    var downloadTask: URLSessionDownloadTask!
    var handler: ((URL, URL)->())?
    var onProgress: ((Double)->())?
    var activeDownloads = [String: DownloadModel]()
    
    private lazy var bgSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "test")
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func startDownload(track: TrackModel) {
        DispatchQueue.global().async {
            if let urlString = track.previewUrl, let url = URL(string: urlString) {
                
                let download = DownloadModel(url: urlString)
                download.downloadTask = self.bgSession.downloadTask(with: url)
                download.downloadTask?.resume()
                download.isDownloading = true
                self.activeDownloads[download.url] = download
                
            }
        }
    }
    
    func stopDownload(track: TrackModel) {
        DispatchQueue.global().async {
            if let urlString = track.previewUrl,
               let download = self.activeDownloads[urlString] {
                if download.isDownloading {
                    download.downloadTask?.cancel(byProducingResumeData: { (data) in
                        if data != nil {
                            download.resumeData = data
                        }
                    })
                    download.isDownloading = false
                }
            }
        }
    }
    
    
    func resumeDownload(track: TrackModel) {
        DispatchQueue.global().async {
            if let urlString = track.previewUrl,
               let download = self.activeDownloads[urlString] {
                if let resumeData = download.resumeData {
                    download.downloadTask = self.bgSession.downloadTask(withResumeData: resumeData)
                    download.downloadTask?.resume()
                    download.isDownloading = true
                }
            }
        }
    }
}

// MARK: -URLSessionDownloadDelegate
extension DataProvider: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did Finish: \(location.absoluteString)")
        
        guard let url = downloadTask.originalRequest?.url else { return }
        self.handler?(url, location)
        
        activeDownloads[url.absoluteString] = nil
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.global().async {
            guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
            
            if let downloadURL = downloadTask.originalRequest?.url?.absoluteString {
                let download = self.activeDownloads[downloadURL]
                download?.progress =  Float(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
            }
            
            let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            print("Download progress: \(progress)")
            
            
            DispatchQueue.main.async {
                self.onProgress?(progress)
            }
        }
    }
}
