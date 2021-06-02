//
//  ViewController.swift
//  Task 2
//
//  Created by piro on 18.05.21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: MusicCell.identifier, bundle: nil), forCellReuseIdentifier: MusicCell.identifier)
        }
    }
    
    private let dataProvider = DataProvider()
    private let mainViewModel = MainViewModel()
    private let trackDetailView: PlayerView = PlayerView.loadFromNib()
    
    var minimazedTopAnchorConstrains: NSLayoutConstraint!
    var maximazedTopAnchorConstrains: NSLayoutConstraint!
    var buttomAnchorConstraint: NSLayoutConstraint!
    var originalAnchorConstraint: NSLayoutConstraint!
    
    weak var delegate: TrackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrackDetailView()
        
        mainViewModel.chekingForTrackAvailability()
    }
    
    private func setupTrackDetailView() {
        trackDetailView.delegate = self
        view.addSubview(trackDetailView)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximazedTopAnchorConstrains = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimazedTopAnchorConstrains = trackDetailView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -64)
        originalAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
        buttomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        buttomAnchorConstraint.isActive = true
        
        maximazedTopAnchorConstrains.isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    
}

//  MARK: -UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicCell.identifier, for: indexPath) as? MusicCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        let track = mainViewModel.tracks[indexPath.row]
        cell.set(track)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = mainViewModel.tracks[indexPath.row]
        
        delegate = self
        
        if track.isDownload == true {
            self.delegate?.maximazeTrackDetailController(track: track)
        }
    }
}

//  MARK: -MusicTVCellDelegate
extension ViewController: MusicCellDelegate {
    func downloadTapped(cell: MusicCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            
            dataProvider.startDownload(track: mainViewModel.tracks[indexPath.row])
            
            self.dataProvider.onProgress = { (progress) in
                cell.progressView.progress = Float(progress)
            }
            
            self.dataProvider.handler = { [weak self] (url, location) in
                self?.mainViewModel.saveInDocuments(url: url, location: location)
                DispatchQueue.main.async {
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func stopTapped(cell: MusicCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            dataProvider.stopDownload(track: mainViewModel.tracks[indexPath.row])
            
        }
        
    }
    
    func resumeTapped(cell: MusicCell) {
        if let indexPath = tableView.indexPath(for: cell) {
    
            dataProvider.resumeDownload(track: mainViewModel.tracks[indexPath.row])
            
            self.dataProvider.onProgress = { (progress) in
                cell.progressView.progress = Float(progress)
                }
            
            self.dataProvider.handler = { [weak self] (url, location) in
                self?.mainViewModel.saveInDocuments(url: url, location: location)
                DispatchQueue.main.async {
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}

//  MARK: -TrackDelegate
extension ViewController: TrackDelegate {
    private func getNextOrPreviousTrack(isForwardTrack: Bool) -> TrackModel? {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil}
        tableView.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
                
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            
            if nextIndexPath.row == mainViewModel.tracks.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = mainViewModel.tracks.count - 1
            }
        }
        tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let track = mainViewModel.tracks[indexPath.row]
        return track
    }
    
    func getPreviousTrack() -> TrackModel {
        return getNextOrPreviousTrack(isForwardTrack: false)!
    }
    
    func getNexTrack() -> TrackModel {
        return getNextOrPreviousTrack(isForwardTrack: true)!
    }
    
    func minimazeTrackDetailController() {
        
        maximazedTopAnchorConstrains.isActive = false
        buttomAnchorConstraint.constant = view.frame.height
        minimazedTopAnchorConstrains.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.trackDetailView.miniPlayer.alpha = 1
                        self.trackDetailView.maxPlayer.alpha = 0
                       }, completion: nil)
    }
    
    func maximazeTrackDetailController(track: TrackModel?) {
        
        maximazedTopAnchorConstrains.isActive = true
        minimazedTopAnchorConstrains.isActive = false
        maximazedTopAnchorConstrains.constant = 0
        buttomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.trackDetailView.miniPlayer.alpha = 0
                        self.trackDetailView.maxPlayer.alpha = 1
                       }, completion: nil)
        
        guard let track = track else { return }
        
        self.trackDetailView.set(track: track)
        
    }
    
    func deleteTrack(track: TrackModel?) {
        guard let track = track else { return }
    
        mainViewModel.isDownloadFalse(for: track)
        
        maximazedTopAnchorConstrains.isActive = false
        buttomAnchorConstraint.constant = view.frame.height
        originalAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                       }, completion: nil)

        
        tableView.reloadData()
    }
    
    
}
