//
//  DetailsTableViewCell.swift
//  SimpleiOSApp
//
//  Created by ADMIN on 11/12/2022.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    static let identifier = "DetailsTableViewCell"
    
    private let detailsTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(detailsTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyConstraints()
    }
    
    private func applyConstraints(){
        let detailsTextLabelConstraints: [NSLayoutConstraint] = [
            detailsTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            detailsTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            detailsTextLabel.topAnchor.constraint(equalTo: topAnchor),
            detailsTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)        
        ]
        NSLayoutConstraint.activate(detailsTextLabelConstraints)
        
    }
    
    public func configureCell(with model: Items){
        detailsTextLabel.text = """
            Type:
            \(model.type)\n
            Avatar URL
            \(model.avatar_url)\n
            Events URL
            \(model.events_url)\n
            Followers URL
            \(model.followers_url)\n
            Following URL
            \(model.following_url)\n
            Gists URL
            \(model.gists_url)\n
            Gravatar URL
            \(model.gravatar_id)\n
            HTML URL
            \(model.html_url)\n
            Organizations URL
            \(model.organizations_url)\n
            Received Events URL
            \(model.received_events_url)\n
            Node ID
            \(model.node_id)\n
            Repos URL
            \(model.repos_url)\n
            Score: \(model.score)\n
        """
    }
    
    

}
