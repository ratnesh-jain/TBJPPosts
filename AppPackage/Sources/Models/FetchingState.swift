//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 26/05/24.
//

import Foundation

public enum FetchingState<T> {
    case fetching
    case fetched(T)
    case error(String)
}

extension FetchingState {
    public var isFetching: Bool {
        guard case .fetching = self else {
            return false
        }
        return true
    }
    
    public var value: T? {
        guard case .fetched(let value) = self else {
            return nil
        }
        return value
    }
    
    public var error: String? {
        guard case .error(let message) = self else {
            return nil
        }
        return message
    }
}
