//
//  MusicTVCell.swift
//  Task 2
//
//  Created by piro on 18.05.21.
//

import UIKit

protocol MusicCellDelegate: class {
    func downloadTapped(cell: MusicCell)
    func stopTapped(cell: MusicCell)
    func resumeTapped(cell: MusicCell)
}

class MusicCell: UITableViewCell {
    
    static let identifier = "MusicCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    weak var delegate: MusicCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressView.tintColor = .black
        progressView.setProgress(0, animated: false)
        progressView.alpha = 0
        
        stopButton.isHidden = true
        resumeButton.isHidden = true
        resumeButton.isEnabled = false
    }
    
    func set(_ track: TrackModel) {
        guard let name = track.name else { return }
        
        nameLabel.text = name
        coverImage.image = UIImage(named: name)
        
        if track.isDownload == true {
            downloadButton.isHidden = true
            stopButton.isHidden = true
            resumeButton.isHidden = true
            progressView.alpha = 0
        } else {
            downloadButton.isHidden = false
        }
    }
    
    @IBAction func downloadTapped(_ sender: UIButton) {
        progressView.alpha = 1
        downloadButton.isHidden = true
        resumeButton.isHidden = false
        stopButton.isHidden = false
        delegate?.downloadTapped(cell: self)
    }
    
    @IBAction func stopTapped(_ sender: UIButton) {
        stopButton.isEnabled = false
        resumeButton.isEnabled = true
        delegate?.stopTapped(cell: self)
    }
    
    @IBAction func resumeTapped(_ sender: UIButton) {
        stopButton.isEnabled = true
        resumeButton.isEnabled = false
        delegate?.resumeTapped(cell: self)
    }
}
