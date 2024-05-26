//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 26/05/24.
//

import Combine
import Foundation
import PostDetailsFeature
import PostListFeature
import ViewModel
import UIKit

@MainActor
public class AppFeature {
    let window: UIWindow
    let viewModel = PostViewModel()
    private var rootViewController: UIViewController?
    private var cancellables: Set<AnyCancellable> = []
    
    public init(window: UIWindow) {
        self.window = window
        self.configureRoot()
        observeViewModel()
    }
    
    private func configureRoot() {
        let rootViewController = PostListViewController(viewModel: self.viewModel)
        self.window.rootViewController = UINavigationController(rootViewController: rootViewController)
        self.window.makeKeyAndVisible()
        self.rootViewController = rootViewController
    }
    
    private func observeViewModel() {
        self.viewModel.delegate.receive(on: DispatchQueue.main).sink { [weak self] delegateEvent in
            guard let self else { return }
            switch delegateEvent {
            case .openPostDetails(let post):
                let vc = PostDetailsViewController(viewModel: .init(state: .init(post: post)))
                self.rootViewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        .store(in: &cancellables)
    }
}
