//
//  APIService.swift
//  SearchBarInTableViewHeader
//
//  Created by 劉子瑜 on 2021/4/22.
//

import Foundation

enum APIError: String, Error {
    case decodeError = "decode receive data error"
    case noNetwork = "No Network"
    case urlComponentsFail = "use URLComponents fail"
    case failTurnUrl = "turn url failure"
    case serverOverload = "Server is overloaded"
}

//https://itunes.apple.com/search?term=劉德華&media=music&country=TW
private let urlString = "https://itunes.apple.com/search"

protocol APIServiceProtocol {
    func fetchSongs(parameters:[String:String],completion:@escaping ( _ success: Bool, _ songs:[Song]?, _ error: APIError?) -> ())
}

class APIService:APIServiceProtocol {    
    func fetchSongs(parameters: [String : String], completion: @escaping ( _ success: Bool, _ songs:[Song]?, _ error: APIError?) -> ()) {
        guard var urlComponents = URLComponents(string: urlString) else {
            completion(false,nil,APIError.urlComponentsFail)
            return
        }
        
        urlComponents.queryItems = []
        
        for (key,value) in parameters {
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        guard let queryedURL = urlComponents.url else {
            completion(false,nil,APIError.failTurnUrl)
            return
        }
        
        let request = URLRequest(url: queryedURL)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let songs = try decoder.decode(Songs.self, from: data!)
                completion(true,songs.results,nil)
            } catch {
                completion(false,nil,APIError.decodeError)
            }
        }

        task.resume()
    }
    
    var parameters: [String : String] = [:]
    
}
