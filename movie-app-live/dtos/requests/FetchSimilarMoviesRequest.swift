//
//  FetchSimilarMoviesRequest.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 06. 24..
//

import Foundation

struct FetchSimilarMoviesRequest {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    let page: Int
    
    init(mediaId: Int, page: Int = 1) {
        self.mediaId = mediaId
        self.page = page
    }
    
    func asRequestParams() -> [String: Any]{
        return ["page": page]
    }
}
