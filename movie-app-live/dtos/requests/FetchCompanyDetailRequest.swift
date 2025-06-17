//
//  FetchCompanyDetailRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 06. 14..
//

import Foundation

struct FetchCompanyDetailRequest {
    let accessToken: String = Config.bearerToken
    let companyId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
