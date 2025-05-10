//
//  AddFavoriteMovieRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 06..
//

struct AddFavoriteRequest {
    let accessToken: String = Config.bearerToken
    let accountId: Int = 21889570
    let movieId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
