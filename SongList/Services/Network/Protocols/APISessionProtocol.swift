//
//  APISessionProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation

typealias SongCompletionHandler = ([Song], APIError?) -> Void

protocol APISessionProtocol {
    func getSongs(completionHandler: @escaping SongCompletionHandler)
}
