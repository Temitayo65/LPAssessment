//
//  MainViewController.swift
//  SimpleiOSApp
//
//  Created by ADMIN on 08/12/2022.
//

import UIKit

class MainViewController: UIViewController{
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        let queryString = "defunkt"
        fetchSearchResults(for: queryString)
        
    }
    
    
    func fetchSearchResults(for queryString: String){
        APICaller.shared.getSearchResults(for: queryString){[weak self] results in
            switch results{
            case .success(let items):
                print(items.total_count)
                
                var count = 0
                for item in items.items{
                    count += 1
                    print(item.login)
                    print(item.avatar_url)
                    print(item.type)
                    print(count)
                    
                    
                }
                DispatchQueue.main.async {
                    self?.view.backgroundColor = .green
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}
