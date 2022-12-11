//
//  DetailsViewController.swift
//  SimpleiOSApp
//
//  Created by ADMIN on 09/12/2022.
//

import UIKit

class DetailsViewController: UIViewController {
    var detailItems: Items?
    
    private var detailsHeaderView: DetailsHeaderView?
    
    private let detailsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: DetailsTableViewCell.identifier)
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(detailsTableView)
        title = "User Details"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsHeaderView = DetailsHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 150))
        
        detailsTableView.tableHeaderView = detailsHeaderView
        configureHeaderView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyConstraints()
    }
    
    func configureHeaderView(){
        detailsHeaderView?.configure(with: detailItems!)
    }
    
    
    func applyConstraints(){
        let detailsTableViewConstraints: [NSLayoutConstraint] = [
            detailsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            detailsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(detailsTableViewConstraints)
    }
}


extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier,for: indexPath) as? DetailsTableViewCell else{return UITableViewCell()}
        
        if let items = detailItems{
            cell.configureCell(with: items)
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  700
    }
    


    
    
}
