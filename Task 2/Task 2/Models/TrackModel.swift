//
//  Track.swift
//  Task 2
//
//  Created by piro on 19.05.21.
//

import Foundation

class TrackModel {
    var name: String?
    var previewUrl: String?
    var isDownload: Bool = false
    
    init(name: String, previewUrl: String) {
        self.name = name
        self.previewUrl = previewUrl
    }
}
