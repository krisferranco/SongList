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
    @IBOutlet weak var backgroundContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundContentView.layer.cornerRadius = 10.0
    }
    
    @IBAction func didTapStateActionButton(_ sender: Any) {
        //Download song, play, pause
        //Depends on state
    }
    
    func bind(_ song: Song) {
        titleLabel.text = song.name
    }
    
}
