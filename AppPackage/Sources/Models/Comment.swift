//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 26/05/24.
//

import Foundation

public struct Comment: Codable, Identifiable, Hashable {
    public var postId: Int
    public var id: Int
    public var name: String
    public var email: String
    public var body: String
    
    public init(postId: Int, id: Int, name: String, email: String, body: String) {
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
}
