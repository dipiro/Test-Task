//
//  TrackDetailView.swift
//  Task 2
//
//  Created by piro on 26.05.21.
//

import Foundation
import UIKit
import AVKit

protocol TrackDelegate: class {
    func getPreviousTrack() -> TrackModel
    func getNexTrack() -> TrackModel
    func minimazeTrackDetailController()
    func maximazeTrackDetailController(track: TrackModel?)
    func deleteTrack(track: TrackModel?)
}

class PlayerView: UIView {
    @IBOutlet weak var miniPlayer: UIView!
    @IBOutlet weak var miniCover: UIImageView!
    @IBOutlet weak var miniName: UILabel!
    
    @IBOutlet weak var maxPlayer: UIStackView!
    @IBOutlet weak var maxCover: UIImageView!
    @IBOutlet weak var maxName: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    var playerViewModel: PlayerViewModel = PlayerViewModel()
    
    weak var delegate: TrackDelegate?
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setGesure()
        
    }
    
    func playTrack(_ name: String) {
        let trackURL = playerViewModel.getTrackURL(name)
        
        guard let trackURl = trackURL else { return }
        
        let playerItem = AVPlayerItem(url: URL(string: trackURl)!)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (time) in
            self.currentTimeLabel.text = time.toDisplayString()
            
            let durationTime = self.player.currentItem?.duration
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self.durationLabel.text = "-\(currentDurationText)"
            self.updateCurrentTimeSlider()
        }
    }
    
    func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSecods = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSecods
        self.timeSlider.value = Float(percentage)
    }
    
    func set(track: TrackModel) {
        guard let trackName = track.name else { return }
        
        player.pause()
        
        playerViewModel.currentTrack = track
        
        miniName.text = trackName
        miniCover.image = UIImage(named: trackName)
        
        maxCover.image = UIImage(named: trackName)
        
        maxName.text = track.name
        
        if track.isDownload {
            playButton.isEnabled = true
            playTrack(trackName)
            observePlayerCurrentTime()
        } else {
            playButton.isEnabled = false
        }
    }
    
    private func setGesure() {
        miniPlayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximazed)))
    }
    
    @objc private func handleTapMaximazed() {
        self.delegate?.maximazeTrackDetailController(track: nil)
    }
    
    
    @IBAction func dragDownTapped(_ sender: Any) {
        self.delegate?.minimazeTrackDetailController()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let percentage = timeSlider.value
        guard let duration = player.currentItem?.duration else {
            return
        }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeUnSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeUnSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func playStopAction(_ sender: UIButton) {
        if player.timeControlStatus == .paused {
            player.play()
        } else {
            player.pause()
        }
    }
    
    @IBAction func previousTack(_ sender: UIButton) {
        guard let previousTrack = delegate?.getPreviousTrack() else { return}
        self.set(track: previousTrack)
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        guard let nextTrack = delegate?.getNexTrack() else { return}
        self.set(track: nextTrack)
    }
    
    @IBAction func deleteTrack(_ sender: UIButton) {
        player.pause()
        
        playerViewModel.deleteTrack()
        
        delegate?.deleteTrack(track: playerViewModel.currentTrack)
    }
}
