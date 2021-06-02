//
//  ViewModel.swift
//  Task 2
//
//  Created by piro on 29.05.21.
//

import Foundation

class MainViewModel {
    
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var tracks = [TrackModel(name: "Creative Minds", previewUrl: "https://www.bensound.com/bensound-music/bensound-creativeminds.mp3"),
                  TrackModel(name: "Little Idea",  previewUrl: "https://www.bensound.com/bensound-music/bensound-littleidea.mp3"),
                  TrackModel(name: "Cute", previewUrl: "https://www.bensound.com/bensound-music/bensound-cute.mp3"),
                  TrackModel(name: "Going Higher",  previewUrl: "https://www.bensound.com/bensound-music/bensound-goinghigher.mp3"),
                  TrackModel(name: "Memories", previewUrl: "https://www.bensound.com/bensound-music/bensound-memories.mp3")
    ]
    
    
    
    func chekingForTrackAvailability() {
        for track in tracks {
            guard let name = track.name else { return }
            
            do {
                let objectsInDocuments = try? FileManager.default.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
                guard let objects = objectsInDocuments else { return }
                
                for object in objects {
                    let objectName = object.lastPathComponent
                    if objectName.contains(name) {
                        track.isDownload = true
                    }
                }
            }
        }
    }
    
    func saveInDocuments(url: URL, location: URL) {
        var name = ""
        
        for track in tracks {
            if track.previewUrl == url.absoluteString {
                name = track.name!
                track.isDownload = true
            }
        }
        
        let destinationURL = documentsPath.appendingPathComponent(name + ".mp3")
        try? FileManager.default.removeItem(at: destinationURL)
        do {
            try? FileManager.default.copyItem(at: location, to: destinationURL)
        }
    }
    
    func isDownloadFalse(for track: TrackModel) {
        track.isDownload = false
    }
}

