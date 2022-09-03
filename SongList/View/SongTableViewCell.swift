//
//  SongTableViewCell.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    static let defaultHeight: CGFloat = 150
    static let reuseIdentifier: String = "SongTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stateActionButton: UIButton!
    @IBOutlet weak var progressView: CircularProgress!
    
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var backgroundContentView: UIView!
    
    var viewModel: SongViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundContentView.layer.cornerRadius = 10.0
    }
    
    @IBAction func didTapStateActionButton(_ sender: Any) {
        guard let viewModel = viewModel else {
            return
        }
        
        switch viewModel.state {
        case .initial:
            viewModel.startDownload()
        case .available:
            viewModel.playAudio()
        case .playing:
            viewModel.pauseAudio()
        default:
            break
        }
    }
    
    /// Update cell components base on the `viewModel` details
    func bind(_ viewModel: SongViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.songName
        viewModel.delegate = self
        
        updatedState(viewModel.state)
    }
    
}

//MARK: SongViewModelDelegate methods
extension SongTableViewCell: SongViewModelDelegate {
    func updatedState(_ state: SongState) {
        switch state {
        case .initial, .available, .playing:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.progressContainerView.isHidden = true
                self.stateActionButton.isHidden = false
                self.stateActionButton.setImage(UIImage(named: state.buttonImageName), for: .normal)
            }
        case .downloading(let progress):
            DispatchQueue.main.async {
                self.progressContainerView.isHidden = false
                self.stateActionButton.isHidden = true
                self.progressView.setProgressWithAnimation(value: progress)
            }
        case .failed(let apiError):
            print(apiError.localizedDescription)
        }
    }
    
}
