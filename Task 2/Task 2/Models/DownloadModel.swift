//
//  Music.swift
//  Task 2
//
//  Created by piro on 18.05.21.
//

import Foundation

class DownloadModel {
    var url: String
    var isDownloading = true
    var progress: Float = 0.0
    
    var downloadTask: URLSessionDownloadTask?
    var resumeData: Data?
    
    init(url: String) {
        self.url = url
    }
}
