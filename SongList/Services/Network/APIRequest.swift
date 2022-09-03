//
//  APIRequest.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/4/22.
//

import Foundation

enum APIRequest {
    
    case songList
    case songDetails(String)
    
    var baseUrl: String {
        let baseUrlString = "https://gist.githubusercontent.com"
        return baseUrlString
    }
    
    var path: String {
        switch self {
        case .songList: return "/Lenhador/a0cf9ef19cd816332435316a2369bc00/raw/a1338834fc60f7513402a569af09ffa302a26b63/Songs.json"
        case .songDetails(let id): return "/details/\(id)"
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseUrl)\(path)")
    }
}
