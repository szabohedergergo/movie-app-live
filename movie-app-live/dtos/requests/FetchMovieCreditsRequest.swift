//
//  FetchMovieCredits.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 11..
//

struct FetchMovieCreditsRequest: LocalizedRequestable{
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any]{
        return languageParam
    }
}
