//
//  SongListViewController.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/1/22.
//

import UIKit

class SongListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var viewModel: SongListViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Register custom cell
        tableView.register(UINib(nibName: String(describing: SongTableViewCell.self), bundle: nil), forCellReuseIdentifier: SongTableViewCell.reuseIdentifier)
        tableView.rowHeight = SongTableViewCell.defaultHeight
        
        viewModel?.delegate = self
        
        /// API call
        activityIndicator.startAnimating()
        viewModel?.fetchSongs()
    }
    
    func bind(_ viewModel: SongListViewModelProtocol) {
        self.viewModel = viewModel
    }

}

extension SongListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.songViewModels.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let viewModel = viewModel,
            indexPath.row < viewModel.songViewModels.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.reuseIdentifier, for: indexPath) as? SongTableViewCell
        else {
            return UITableViewCell()
        }

        let songViewModel = viewModel.songViewModels[indexPath.row]
        cell.bind(songViewModel)
        return cell
    }
}

extension SongListViewController: SongListViewModelDelegate {
    func songsUpdated() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    func receivedError(_ error: APIError) {
        print("Error received \(error)")
    }
}


