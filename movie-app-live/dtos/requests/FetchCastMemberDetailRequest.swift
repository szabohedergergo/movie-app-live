//
//  FetchPersonDetailRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 06. 14..
//

import Foundation

struct FetchCastMemberDetailRequest {
    let accessToken: String = Config.bearerToken
    let castMemberId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
