//
//  APICaller.swift
//  SimpleiOSApp
//
//  Created by ADMIN on 08/12/2022.
//

import Foundation
import OctoKit

enum APIError: Error{
    case failedToGetData
}

class APICaller{
    
    
    static let shared = APICaller()
    
    func getSearchResults(for queryString: String, completion: @escaping (Result<SearchResults,(Error)>) -> Void){
        let query = queryString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? slice(queryString, from: 0, to: " ")!
        guard let url = URL(string: "\(Constants.baseURL)/search/users?q=\(query)") else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){
            data,_,error in
            guard let data = data, error == nil else {return}
            do{
                let result = try JSONDecoder().decode(SearchResults.self, from: data)
                completion(.success(result))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
}
