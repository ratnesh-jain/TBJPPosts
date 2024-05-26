//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 26/05/24.
//

import Foundation
import Models

public protocol ServiceProvider {
    func fetchPost(page: Int, limit: Int) async throws -> [Post]
    func fetchPostComments(postId: Int) async throws -> [Comment]
}

public class LiveService: Service, ServiceProvider {
    public func fetchPost(page: Int, limit: Int) async throws -> [Post] {
        try await self.fetch(path: Endpoint.posts(page: page, limit: limit))
    }
    
    public func fetchPostComments(postId: Int) async throws -> [Comment] {
        try await self.fetch(path: Endpoint.comments(postId: postId))
    }
}

public enum LiveServiceClient {
    public static var liveValue: ServiceProvider = {
        LiveService(baseURL: URL(string: "https://jsonplaceholder.typicode.com")!)
    }()
}
