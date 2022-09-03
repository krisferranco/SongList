//
//  APISessionProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation

typealias APICompletionHandler = (Codable?, APIError?) -> Void

protocol APISessionProtocol {
    func request<T: Codable>(_ request: APIRequest, type: T.Type, completionHandler: @escaping APICompletionHandler)
}
