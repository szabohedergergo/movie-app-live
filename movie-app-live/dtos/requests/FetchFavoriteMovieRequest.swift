//
//  FetchFavoriteMovieRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 06..
//

struct FetchFavoriteMoviesRequest {
    let accessToken: String = Config.bearerToken
    let accountId: Int = 21889570
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
