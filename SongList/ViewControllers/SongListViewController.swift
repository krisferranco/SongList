//
//  SongListViewController.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/1/22.
//

import UIKit

class SongListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //temporary injection
    let viewModel = SongListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Register custom cell
        tableView.register(UINib(nibName: String(describing: SongTableViewCell.self), bundle: nil), forCellReuseIdentifier: SongTableViewCell.reuseIdentifier)
        tableView.rowHeight = SongTableViewCell.defaultHeight
        
        viewModel.delegate = self
        viewModel.fetchSongs()
    }

}

extension SongListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            indexPath.row < viewModel.songViewModels.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.reuseIdentifier, for: indexPath) as? SongTableViewCell
        else {
            return UITableViewCell()
        }

        ///Update Cell details
        let songViewModel = viewModel.songViewModels[indexPath.row]
        cell.bind(songViewModel)
        return cell
    }
}

extension SongListViewController: SongListViewModelDelegate {
    func songsUpdated() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func receivedError(_ error: APIError) {
        print("Error received \(error)")
    }
}


