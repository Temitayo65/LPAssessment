//
//  ResultsTableViewCell.swift
//  SimpleiOSApp
//
//  Created by ADMIN on 10/12/2022.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    
    static let identifier = "ResultsTableViewCell"
    private let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private let avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImage)
        contentView.addSubview(userLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyConstraints()
    }
    
    
    func applyConstraints(){
        let avatarImageConstraints : [NSLayoutConstraint] = [
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            avatarImage.heightAnchor.constraint(equalToConstant: 40),
            avatarImage.widthAnchor.constraint(equalToConstant: 40)
        
        
        ]
        
        let userLabelConstraints : [NSLayoutConstraint] = [
            userLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 10),
            userLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            userLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            userLabel.heightAnchor.constraint(equalToConstant: 25)
        
        ]
        
        NSLayoutConstraint.activate(avatarImageConstraints)
        NSLayoutConstraint.activate(userLabelConstraints)
        
    }
    
    public func configureCell(with model: Items, for cache: NSCache<NSURL, UIImage>) -> (NSCache<NSURL, UIImage>) {
        
        userLabel.text = model.login
        guard let url = URL(string: model.avatar_url) else{return cache}
        // Check if the image is in the cache
            if let cachedImage = cache.object(forKey: url as NSURL) {
                // If the image is in the cache, set it on the cell and return
                avatarImage.image = cachedImage
            }
            // If the image is not in the cache, load it from the URL
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    // If the image was loaded successfully, add it to the cache and set it on the cell
                    cache.setObject(image, forKey: url as NSURL)
                    DispatchQueue.main.async {
                        self?.avatarImage.image = image
                    }
                }
            }
            task.resume()
            return cache
    }
    
}
