//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 26/05/24.
//

import Foundation

protocol PathProvider {
    var path: String { get }
    var queries: [URLQueryItem] { get }
}

public enum Endpoint: PathProvider {
    case posts(page: Int, limit: Int)
    case comments(postId: Int)
    
    public var path: String {
        switch self {
        case .posts:
            return "posts"
        case .comments(let postId):
            return "posts/\(postId)/comments"
        }
    }
    
    public var queries: [URLQueryItem] {
        switch self {
        case .posts(let page, let limit):
            return [
                URLQueryItem(name: "_page", value: "\(page)"),
                URLQueryItem(name: "_limit", value: "\(limit)")
            ]
        case .comments:
            return []
        }
    }
}
