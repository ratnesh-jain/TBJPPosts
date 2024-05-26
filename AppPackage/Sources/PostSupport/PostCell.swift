//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 26/05/24.
//

import Foundation
import Models
import UIKit

public class PostCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .semibold)
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
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(bodyLabel)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        bodyLabel.setContentHuggingPriority(.init(15), for: .vertical)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            bodyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            bodyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
        ])
    }
    
    public func configure(post: Post) {
        self.titleLabel.text = "\(post.id)) \(post.title)"
        self.bodyLabel.text = post.body
    }
}

#Preview {
    let cell = PostCell()
    cell.configure(post: Post(userId: 1, id: 1, title: "Title", body: "Body"))
    return cell
}
