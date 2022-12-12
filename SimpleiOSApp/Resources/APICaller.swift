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
    
    func getSearchResults(pagination: Bool = false, for queryString: String, completion: @escaping (Result<SearchResults,(Error)>) -> Void){
        if pagination{self.isPaginating = true}
        
        let query = modifyQuery(with: queryString)

        guard let url = URL(string: "\(Constants.baseURL)/search/users?q=\(query)&page=\(self.pageCount)&sort=asc&per_page=10") else{return}
            
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){
                data,_,error in
                guard let data = data, error == nil else {return}
                do{
                    let result = try JSONDecoder().decode(SearchResults.self, from: data)
                    completion(.success(result))
                    self.increasePageCount(for: result.total_count)
                    
                    if pagination{self.isPaginating = false}
                    
                }catch{completion(.failure(APIError.failedToGetData))}
            }
            task.resume()
      
    }
    
    public func modifyQuery(with queryString: String)->String{
        if queryString.contains(where: { string in
            string == " "}){
            let result = slice(queryString, from: 0, to: " ")
            return result!
        }
        return queryString
    }
    
    
    private func increasePageCount(for pageTotal: Int){
        if pageCount < pageTotal{
            pageCount += 1
        }
        else{
            isPaginating = false
        }
    }
    
    public func resetPageCount(){
        pageCount = 1
    }
    
    public func getPageCount()-> Int{
        return pageCount
    }

}
