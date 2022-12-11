//
//  DetailsHeaderView.swift
//  SimpleiOSApp
//
//  Created by ADMIN on 11/12/2022.
//

import UIKit

class DetailsHeaderView: UIView {
    
    private let detailsAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        
        return imageView
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()

    // initializer for this view The frame is set from when it is initialized in a view controller
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(detailsAvatarImageView)
        addSubview(userLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    

    
    public func configure(with model: Items){
        guard let url = URL(string: model.avatar_url) else{return }
        detailsAvatarImageView.sd_setImage(with: url, completed: nil)
        userLabel.text = model.login
        userLabel.textAlignment = .center
        
    }
    
    
    
    private func applyConstraints(){
        
        let detailsAvatarImageViewConstraints = [
            detailsAvatarImageView.widthAnchor.constraint(equalToConstant: 100),
            detailsAvatarImageView.heightAnchor.constraint(equalToConstant: 100),
            detailsAvatarImageView.topAnchor.constraint(equalTo: topAnchor),
            detailsAvatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        let userLabelConstraints = [
            userLabel.topAnchor.constraint(equalTo: detailsAvatarImageView.bottomAnchor, constant: 10),
            userLabel.centerXAnchor.constraint(equalTo: detailsAvatarImageView.centerXAnchor),
            userLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(detailsAvatarImageViewConstraints)
        NSLayoutConstraint.activate(userLabelConstraints)
    }
    
  


}
