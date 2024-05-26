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
public class PostDetailsViewModel {
    public struct State {
        public let post: Post
        public var comments: [Comment] = []
        public var fetchingState: FetchingState<[Comment]> = .fetching
        
        public init(post: Post) {
            self.post = post
        }
    }
    
    public enum Action {
        case system(SystemAction)
        
        public enum SystemAction {
            case viewDidLoad
            case didReceive(_ fetchingState: FetchingState<[Comment]>)
        }
    }
    
    @Published public private(set) var state: State
    
    public init(state: State) {
        self.state = state
    }
    
    private var service: ServiceProvider = LiveServiceClient.liveValue
    
    public func send(_ action: Action) {
        self.reduce(state: &state, action: action)
    }
    
    private func reduce(state: inout State, action: Action) {
        switch action {
        case .system(.viewDidLoad):
            let postId = state.post.id
            Task {
                do {
                    let comments = try await service.fetchPostComments(postId: postId)
                    self.send(.system(.didReceive(.fetched(comments))))
                } catch {
                    self.send(.system(.didReceive(.error(error.localizedDescription))))
                }
            }
            
        case .system(.didReceive(let fetchingState)):
            state.fetchingState = fetchingState
            
            if let value = fetchingState.value {
                state.comments = value
            }
        }
    }
}
