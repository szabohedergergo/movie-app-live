//
//  FetchMovieReviewsRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 06. 24..
//


import Foundation

struct FetchMovieReviewsRequest{
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any]{
        return [:]
    }
} 