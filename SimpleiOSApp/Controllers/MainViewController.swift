//
//  MainViewController.swift
//  SimpleiOSApp
//
//  Created by ADMIN on 08/12/2022.
//

import UIKit

class MainViewController: UIViewController{
    
    private var searchQuery: String = ""
    
    private let searchTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type your Search Query"
        textField.textAlignment = .center
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemFill
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        
        hideKeyboardWhenTappedAround()
        searchTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyConstraints()
    }

    
    private func applyConstraints(){
        let searchTextFieldConstraints: [NSLayoutConstraint] = [
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(searchTextFieldConstraints)
        
        let searchButtonConstraints: [NSLayoutConstraint] = [
            searchButton.centerXAnchor.constraint(equalTo: searchTextField.centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(searchButtonConstraints)
    }
    
    func searchButtonTapped(for searchQuery: String){
             APICaller.shared.getSearchResults(for: searchQuery){[weak self] results in
                 switch results{
                 case .success(let result):
                     DispatchQueue.main.async {
                         let vc = ResultsViewController()
                         vc.searchResult = result
                         vc.searchQuery = searchQuery
                         self?.navigationController?.pushViewController(vc, animated: true)
                     }
                     
                 case .failure:
                     DispatchQueue.main.async {
                         let alertController = UIAlertController(title: "Search Input Required", message: "Type a search input for your search", preferredStyle: .alert)
                         let alerAction = UIAlertAction(title: "Ok", style: .cancel)
                         alertController.addAction(alerAction)
                         self?.present(alertController, animated: true)
                     }
                     
                 }
             }
     }
}


extension MainViewController: UITextFieldDelegate{


    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let inputValue = textField.text{
            searchQuery = inputValue
            searchButtonTapped(for: searchQuery)
            textField.resignFirstResponder()
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APICaller.shared.resetPageCount()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    @objc func keyboardWillChange(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if searchTextField.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height + searchTextField.frame.size.height + searchButton.frame.size.height
            }
        }
    }

    
    
}

