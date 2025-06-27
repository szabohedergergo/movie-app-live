//
//  FetchCombinedCreditsRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 06. 28..
//

struct FetchCombinedCreditsRequest {
    let accessToken: String = Config.bearerToken
    let personId: Int
    
    func asReqestParams() -> [String: String]{
        return [:]
    }
}
