//
//  APISessionProtocol.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation

typealias APICompletionHandler = (Codable?, APIError?) -> Void

/// Handles the API calls request depending on the `request` parameter details to make the request
protocol APISessionProtocol {
    
    /**
     Handles the api request call
     
     - Parameters:
        - request: consist of request details defined from `APIRequest`
     
        - type: specific type that conforms to `Codable` where the response will be mapped to
        - completionHandler: completion block that receives the Codable model or error depending on the response
     */
    func request<T: Codable>(_ request: APIRequest, type: T.Type, completionHandler: @escaping APICompletionHandler)
}
