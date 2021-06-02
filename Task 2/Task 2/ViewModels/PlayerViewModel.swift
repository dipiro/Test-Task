//
//  PlayerViewModel.swift
//  Task 2
//
//  Created by piro on 2.06.21.
//

import Foundation

class PlayerViewModel {
    private let fileManager = FileManager()
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var currentTrack: TrackModel?
    
    func getTrackURL(_ name: String) -> String? {
        do {
            let contentOfDirectory = try fileManager.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            
            for object in contentOfDirectory {
                let objectName = object.lastPathComponent
                if objectName.contains(name) {
                    return object.absoluteString
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func deleteTrack() {
        
        guard let trackName = currentTrack?.name else { return }
        
        let destinationURL = documentsPath.appendingPathComponent( trackName + ".mp3")
        
        do {
            try? FileManager.default.removeItem(at: destinationURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
