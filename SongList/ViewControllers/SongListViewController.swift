//
//  SongListViewController.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/1/22.
//

import UIKit

class SongListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Register custom cell
        tableView.register(UINib(nibName: String(describing: SongTableViewCell.self), bundle: nil), forCellReuseIdentifier: SongTableViewCell.reuseIdentifier)
        tableView.rowHeight = SongTableViewCell.defaultHeight
    }

}

extension SongListViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 5
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.reuseIdentifier, for: indexPath) as? SongTableViewCell
        else {
            return UITableViewCell()
        }

        ///Update Cell details
        
        return cell
    }
}


