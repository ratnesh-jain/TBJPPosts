//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 26/05/24.
//

import Combine
import Foundation
import Models
import ViewModel
import PostSupport
import UIKit
import UIUtilities

public class PostListViewController: UIViewController {
    let viewModel: PostViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    public init(viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Please use init(viewModel:)")
    }
    
    public enum Section: Hashable {
        case main
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(
            PostCell.self,
            forCellReuseIdentifier: String(describing: PostCell.self)
        )
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var fetchingView: FetchingView = {
        FetchingView(listView: self.tableView, parentView: self.view)
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Post> = {
        let dataSource = UITableViewDiffableDataSource<Section, Post>(tableView: self.tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostCell.self)) as? PostCell
            cell?.configure(post: itemIdentifier)
            return cell
        }
        return dataSource
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        observeViewModel()
        viewModel.send(.system(.viewDidLoad))
    }
    
    private func configureViews() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        self.navigationItem.title = "Posts"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func observeViewModel() {
        self.viewModel.$state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.configureFetchingState(state: state)
                self?.applySnapshot(state: state)
            }
            .store(in: &cancellables)
    }
    
    private func applySnapshot(state: PostViewModel.State) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        snapshot.appendSections([.main])
        snapshot.appendItems(state.posts, toSection: .main)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureFetchingState(state: PostViewModel.State) {
        switch state.fetchingState {
        case .fetching:
            self.fetchingView.fetchingState = .fetching
        case .fetched:
            self.fetchingView.fetchingState = .fetched
        case .error(let string):
            self.fetchingView.fetchingState = .error(.init(message: string))
        }
    }
    
    private func configureNextPageLoading(state: PostViewModel.State) {
        if state.isFetchingNext {
            self.tableView.tableFooterView = self.fetchingView.loadMoreIndicatorView
        } else {
            self.tableView.tableFooterView = nil
        }
    }
}

extension PostListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.send(.system(.didScroll(indexPath: indexPath)))
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
        self.viewModel.send(.user(.didSelectPost(item)))
    }
}

#Preview {
    PostListViewController(viewModel: .init())
}

