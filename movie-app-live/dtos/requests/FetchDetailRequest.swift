//
//  FetchDetailRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 10..
//

struct FetchDetailRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any] {
        return languageParam
    }
}
