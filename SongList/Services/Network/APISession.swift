//
//  APISession.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import Foundation

private let baseUrl: String = "https://gist.githubusercontent.com"
private let songListUrl: String = "/Lenhador/a0cf9ef19cd816332435316a2369bc00/raw/a1338834fc60f7513402a569af09ffa302a26b63/Songs.json"

typealias SongCompletionHandler = ([Song], APIError?) -> Void

class APISession {
    
    static let shared = APISession()
    
    private init() { }
    
    func getSongs(completionHandler: @escaping SongCompletionHandler) {
        guard
            let songUrl = URL(string: "\(baseUrl)\(songListUrl)")
        else {
            //Return invalid url erro to completion handler
            completionHandler([], .invalidRequest)
            return
        }
         let dataTask = URLSession.shared.dataTask(with: songUrl) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                //Return api error to completion handler
                completionHandler([], .serverError(error.localizedDescription))
            }
            
            let decoder = JSONDecoder()
            guard
                let responseData = data,
                let songListResponse = try? decoder.decode(SongListResponse.self, from: responseData)
            else {
                //Return invalid response/malformed to completion handler
                completionHandler([], .invalidResponse)
                return
            }
            
            completionHandler(songListResponse.data, nil)
        }
        
        dataTask.resume()
    }
}
