//
//  MovieCreditsResponse.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 11..
//

import Foundation

struct MovieCreditsResponse: Codable {
    let id: Int
    let cast: [CastMemberResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
    }
}
