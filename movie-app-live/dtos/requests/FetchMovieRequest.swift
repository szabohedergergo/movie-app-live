//
//  FetchMovieRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 15..
//

struct FetchMediaListRequest {
    let accessToken: String = Config.bearerToken
    let genreId: Int
    
    func asRequestParams() -> [String: Any] {
        return ["with_genres": genreId]
    }
}

//struct FetchFavoriteMoviesRequest {
//    let accessToken: String = Config.bearerToken
//    let ids: [Int]
//
//    func asRequestParams() -> [String: Any] {
//        return ["ids": ids.map(String.init).joined(separator: ",")]
//    }
//}
