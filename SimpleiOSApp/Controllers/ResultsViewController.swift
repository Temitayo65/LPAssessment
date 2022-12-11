//
//  ResultsViewController.swift
//  SimpleiOSApp
//
//  Created by ADMIN on 09/12/2022.
//

import UIKit

class ResultsViewController: UIViewController {
   
    var searchResult: SearchResults?
    var searchQuery: String!
    
    var tableViewResults: [Items] = [Items]()
    
    private let resultsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .black
        table.register(ResultsTableViewCell.self, forCellReuseIdentifier: ResultsTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Results"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .black
        view.addSubview(resultsTableView)
        
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        
        tableViewResults.append(contentsOf: searchResult!.items)
        tableViewResults.sort{$0.login.lowercased() < $1.login.lowercased()}

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
    
   
}


extension ResultsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultsTableViewCell.identifier, for: indexPath) as? ResultsTableViewCell else{return UITableViewCell()}
        let model = tableViewResults[indexPath.row]
        cell.configureCell(with: model)
        cell.backgroundColor = .clear
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
            
            guard !APICaller.shared.isPaginating else {return}
            self.resultsTableView.tableFooterView = createSpinenrFooter()
            
            APICaller.shared.getSearchResults(pagination: true,for: searchQuery){[weak self] results in
                DispatchQueue.main.async {
                    self?.resultsTableView.tableFooterView = nil
                }
                switch results{
                case .success(let data):
                    DispatchQueue.main.async {
                        var arrayItems = data.items // array items after call
                        arrayItems.sort{$0.login.lowercased() < $1.login.lowercased()} // sort them here
                        self?.tableViewResults.append(contentsOf: arrayItems) // increase the result
                        self?.resultsTableView.reloadData()
                    }
                    
                case.failure(_):
                    break // handle this later
                    
                    
                }
                
            }
        }
    }
    
    

}
