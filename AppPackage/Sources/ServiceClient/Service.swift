//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 26/05/24.
//

import Foundation

public class Service {
    private var baseURL: URL
    private var urlSession: URLSession
    private var jsonDecoder: JSONDecoder
    
    public init(baseURL: URL, urlSession: URLSession = .shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.jsonDecoder = JSONDecoder()
    }
    
    private func url(using path: PathProvider) -> URL {
        self.baseURL
            .appending(path: path.path)
            .appending(queryItems: path.queries)
    }
    
    func fetch<T: Decodable>(path: PathProvider) async throws -> T {
        let (data, _) = try await self.urlSession.data(from: url(using: path))
        let item = try jsonDecoder.decode(T.self, from: data)
        return item
    }
}
