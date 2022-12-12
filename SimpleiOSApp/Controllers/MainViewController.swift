//
//  MainViewController.swift
//  SimpleiOSApp
//
//  Created by ADMIN on 08/12/2022.
//

import UIKit

class MainViewController: UIViewController{
    
    private let apiCaller = APICaller()
    
    private var searchQuery: String = ""
    private let searchTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.textColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "Type your Search Query",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .purple
        button.backgroundColor = .cyan
        button.layer.cornerRadius = 10
        button.addTarget(nil, action: #selector(titleForButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func titleForButtonTapped(){
        searchButtonTapped(for: searchQuery)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .darkGray
        view.addSubview(searchTextField)
        view.addSubview(searchButton)

        searchTextField.delegate = self
        searchTextField.clearButtonMode = .always
        searchTextField.clearButtonMode = .whileEditing
        
        hideKeyboardWhenTappedAround()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyConstraintsForSubviews()
    }

    
    private func applyConstraintsForSubviews(){
        let searchTextFieldConstraints: [NSLayoutConstraint] = [
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(searchTextFieldConstraints)
        
        let searchButtonConstraints: [NSLayoutConstraint] = [
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.centerXAnchor.constraint(equalTo: searchTextField.centerXAnchor)
        ]
        NSLayoutConstraint.activate(searchButtonConstraints)
    }

    
    func searchButtonTapped(for searchQuery: String){
        if !searchQuery.isEmpty{
            apiCaller.getSearchResults(for: searchQuery){[weak self] results in
                switch results{
                case .success(let result):
                    DispatchQueue.main.async {
                        let vc = ResultsViewController()
                        vc.searchResult = result
                        vc.searchQuery = searchQuery
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Invalid Request", message: "Check your internet connection\n\(error.localizedDescription)", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
                        alertController.addAction(alertAction)
                        self?.present(alertController, animated: true)
                    }
                    
                }
            }
        }
        
        else {
            let alertController = UIAlertController(title: "Search Input Required", message: "Type a search input for your search", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
        }
    }
}


extension MainViewController: UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let inputValue = textField.text{
            searchQuery = inputValue
            return true
        }
        return false
        
    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location > 40{ // limiting search query to 40 characters
            return false
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchQuery = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = textField.text{
            searchButtonTapped(for: query)
            return true
        }
        else{
            textField.text = ""
            return false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCaller.resetPageCount() // reset the pageCount by the APICaller
      
    }

    
    
}

