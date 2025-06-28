//
//  SearchMovieRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

struct SearchMediaItemRequest {
    let accessToken: String = Config.bearerToken
    let query: String
    
    func asRequestParams() -> [String: Any] {
        return [
            "query": query
        ]
    }
}
