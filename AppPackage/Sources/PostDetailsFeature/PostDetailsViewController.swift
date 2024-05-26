//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 26/05/24.
//

import Combine
import Foundation
import UIKit
import Models
import PostSupport
import ViewModel

public class PostDetailsViewController: UIViewController {
    let viewModel: PostDetailsViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    public enum Section: Hashable, RawRepresentable {
        public init?(rawValue: String) {
            switch rawValue {
            case "Post":
                self = .post
            case "Comment":
                self = .comments
            default:
                return nil
            }
        }
        
        case post
        case comments
        
        public var rawValue: String {
            switch self {
            case .post:
                return "Post"
            case .comments:
                return "Comments"
            }
        }
    }
    
    public enum Row: Hashable {
        case post(Post)
        case comment(Comment)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostCell.self, forCellReuseIdentifier: String(describing: PostCell.self))
        tableView.register(CommentCell.self, forCellReuseIdentifier: String(describing: CommentCell.self))
        return tableView
    }()
    
    private lazy var dataSource: AppTableViewDiffableDataSource<Section, Row> = {
        let dataSource = AppTableViewDiffableDataSource<Section, Row>(tableView: self.tableView) { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .post(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostCell.self), for: indexPath) as? PostCell
                cell?.configure(post: post)
                return cell
                
            case .comment(let comment):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentCell.self), for: indexPath) as? CommentCell
                cell?.configure(comment: comment)
                return cell
            }
        }
        return dataSource
    }()
    
    public init(viewModel: PostDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Please use init(viewModel:post)")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        observeViewModel()
        self.viewModel.send(.system(.viewDidLoad))
    }
    
    private func configureViews() {
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.navigationItem.title = "Post \(viewModel.state.post.id)"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func observeViewModel() {
        self.viewModel.$state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.applySnapshot(state: state)
            }
            .store(in: &cancellables)
    }
    
    private func applySnapshot(state: PostDetailsViewModel.State) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.post, .comments])
        snapshot.appendItems([.post(state.post)], toSection: .post)
        snapshot.appendItems(state.comments.map { .comment($0) }, toSection: .comments)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
