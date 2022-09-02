//
//  APIError.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import Foundation

enum APIError: Error {
    
    case invalidRequest
    case invalidResponse
    case serverError(String?)
    
}
