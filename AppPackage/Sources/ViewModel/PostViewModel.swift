//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 26/05/24.
//

import Combine
import Foundation
import Models
import ServiceClient
import UIKit

@MainActor
public class PostViewModel {
    
    public struct State {
        public let limit: Int = 10
        public var currentPage: Int = 1
        public var fetchingState: FetchingState<[Post]> = .fetching
        public var posts: [Post] = []
        public var comments: [Post.ID: [Comment]] = [:]
        public var isFetchingNext: Bool = false
    }
    
    public enum Action {
        case system(SystemAction)
        case user(UserAction)
        
        public enum SystemAction {
            case viewDidLoad
            case fetch(page: Int, limit: Int)
            case didScroll(indexPath: IndexPath)
            case didReceive(_ fetchingState: FetchingState<[Post]>)
        }
        
        public enum UserAction {
            case didSelectPost(Post)
        }
    }
    
    public enum DelegateEvent {
        case openPostDetails(Post)
    }
    
    public init() {}
    
    private var service: ServiceProvider = LiveServiceClient.liveValue
    @Published public private(set) var state: State = .init()
    public private(set) var delegate: PassthroughSubject<DelegateEvent, Never> = .init()
    
    public func send(_ action: Action) {
        self.reduce(state: &state, action: action)
    }
    
    private func reduce(state: inout State, action: Action) {
        switch action {
        case .system(.viewDidLoad):
            let page = state.currentPage
            let limit = state.limit
            send(.system(.fetch(page: page, limit: limit)))
            
        case .system(.fetch(let page, let limit)):
            if page == 1 {
                self.state.fetchingState = .fetching
            } else {
                self.state.isFetchingNext = true
            }
            Task {
                do {
                    let posts = try await service.fetchPost(page: page, limit: limit)
                    self.send(.system(.didReceive(.fetched(posts))))
                } catch {
                    self.send(.system(.didReceive(.error(error.localizedDescription))))
                }
            }
            
        case .system(.didScroll(let indexPath)):
            if indexPath.row == state.posts.count - 1, !state.fetchingState.isFetching {
                state.currentPage += 1
                send(.system(.fetch(page: state.currentPage, limit: state.limit)))
            }
            
        case .system(.didReceive(let fetchingState)):
            state.fetchingState = fetchingState
            
            state.isFetchingNext = false
            guard let posts = fetchingState.value else { return }
            if state.currentPage == 1 {
                state.posts = posts
            } else {
                state.posts.append(contentsOf: posts)
            }
            
        case .user(.didSelectPost(let post)):
            self.delegate.send(.openPostDetails(post))
        }
    }
    
}
