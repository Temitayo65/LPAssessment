//
//  ResultsViewController.swift
//  SimpleiOSApp
//
//  Created by ADMIN on 09/12/2022.
//

import UIKit

class ResultsViewController: UIViewController {
   
    private var apiCaller = APICaller()
    var searchResult: SearchResults!
    var searchQuery: String!
    var imageCache = NSCache<NSURL, UIImage>()

    var tableViewResults: [Items] = [Items]()
    
    private let resultsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.register(ResultsTableViewCell.self, forCellReuseIdentifier: ResultsTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Results"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .white
        view.addSubview(resultsTableView)
        
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        
        tableViewResults.append(contentsOf: searchResult.items)
        respondToSearchResult()

    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyConstraints()
     
    }
    
    private func applyConstraints(){
        
        let resultsTableViewConstraints: [NSLayoutConstraint] = [
            resultsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(resultsTableViewConstraints)
    }
    
    
    private func respondToSearchResult(){
        if tableViewResults.isEmpty{
            let alertController = UIAlertController(title: "No Search Results", message: "Try Again!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .cancel){[weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(alertAction)
            present(alertController, animated: true)
        }

    }
   
}


extension ResultsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultsTableViewCell.identifier, for: indexPath) as? ResultsTableViewCell else{return UITableViewCell()}
        let model = tableViewResults[indexPath.row]
        
        cell.backgroundColor = .white
        imageCache = cell.configureCell(with: model, for: imageCache) // sets the image and returns the cache also
        return cell
        }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailsViewController()
        vc.detailItems = tableViewResults[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createSpinenrFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { //calling the API when it has reached bottom scroll
        let position = scrollView.contentOffset.y - 100
        if position > (resultsTableView.contentSize.height-scrollView.frame.size.height) {
            
            guard !apiCaller.isPaginating else {return}
            self.resultsTableView.tableFooterView = createSpinenrFooter()
            
            apiCaller.getSearchResults(pagination: true,for: searchQuery){[weak self] results in
                DispatchQueue.main.async {
                    self?.resultsTableView.tableFooterView = nil
                }
                switch results{
                case .success(let data):
                    DispatchQueue.main.async {
                        var arrayItems = data.items // array items after call - api sends the descending sort order from the APICall
                        //arrayItems.sort{$0.login.lowercased() < $1.login.lowercased()} // sort them here in ascending order
                        if self?.tableViewResults != arrayItems{
                            self?.tableViewResults.append(contentsOf: arrayItems)
                        } // increase the result if the result is not in the array already
                        self?.resultsTableView.reloadData()
                    }
                    
                case.failure(_):
                    break // handle this later
                    
                    
                }
                
            }
        }
    }
    
    

}
