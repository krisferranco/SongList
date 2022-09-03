//
//  APISession.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import Foundation

/**
 - Handles the API calls request depending on the `request` parameter details to make the request
 - Maps the server response to the expected Codable model type passed on `type` parameter
 - Depending on the response, the request method will pass the mapped response or error to the `completionHandler`
*/
class APISession: APISessionProtocol {
    
    func request<T: Codable>(_ request: APIRequest,
                             type: T.Type,
                             completionHandler: @escaping APICompletionHandler) {
        
        guard let url = request.url else {
            completionHandler(nil, .invalidRequest)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(nil, .serverError(error.localizedDescription))
            }
            
            let decoder = JSONDecoder()
            guard
                let responseData = data,
                let codableResponse = try? decoder.decode(T.self, from: responseData)
            else {
                completionHandler(nil, .invalidResponse)
                return
            }
            completionHandler(codableResponse, nil)
        }
        
        dataTask.resume()
    }
}
