//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 26/05/24.
//

import Foundation
import Models
import UIKit

public class CommentCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    private func configureViews() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(emailLabel)
        self.contentView.addSubview(bodyLabel)
        nameLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        bodyLabel.setContentHuggingPriority(.init(15), for: .vertical)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            emailLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            emailLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 8),
            emailLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            bodyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            bodyLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            bodyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            bodyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
        ])
    }
    
    public func configure(comment: Comment) {
        self.nameLabel.text = comment.name
        self.emailLabel.text = comment.email
        self.bodyLabel.text = comment.body
    }
}

#Preview {
    let cell = CommentCell()
    cell.configure(comment: Comment(postId: 1, id: 1, name: "User", email: "user@mail.com", body: "Comment body"))
    return cell
}

