//
//  FetchFavoriteMovieRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 06..
//

struct FetchFavoriteMediaRequest {
    let accessToken: String = Config.bearerToken
    let accountId: Int = Config.accountId
    
    func asRequestParams() -> [String: Any] {
        return languageParam
    }
}
