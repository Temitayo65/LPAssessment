//
//  APICaller.swift
//  SimpleiOSApp
//
//  Created by ADMIN on 08/12/2022.
//

import Foundation
enum APIError: Error{
    case failedToGetData
}

class APICaller{
    
    private var pageCount = 1
    
    var isPaginating = false
    static let shared = APICaller()
    
    func getSearchResults(pagination: Bool = false, for queryString: String, completion: @escaping (Result<SearchResults,(Error)>) -> Void){
        
        if pagination{
            self.isPaginating = true
            
        }
        
        let query = queryString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self.slice(queryString, from: 0, to: " ")!
            
        guard let url = URL(string: "\(Constants.baseURL)/search/users?q=\(query)&page=\(self.pageCount)&sort=asc&per_page=10") else{return}
            
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){
                data,_,error in
                guard let data = data, error == nil else {return}
                do{
                    let result = try JSONDecoder().decode(SearchResults.self, from: data)
                    completion(.success(result))
                    self.increasePageCount(for: result.total_count)
                    print(result.total_count)
                    print(result.items.count)
                    if pagination{
                        self.isPaginating = false
                    }
                }catch{
                    completion(.failure(APIError.failedToGetData))
                    
                }
            }
            task.resume()
      
    }
    
    private func increasePageCount(for pageTotal: Int){
        if pageCount < pageTotal{
            pageCount += 1
        }
        else{
            isPaginating = false
        }
        print("Current page", pageCount)
    }
    
    public func resetPageCount(){
        pageCount = 1
        print("Resetting page count to", pageCount)
    }

}
