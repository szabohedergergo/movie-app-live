//
//  CombinedCreditsResponse.swift.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 06. 28..
//

struct CombinedCreditsResponse: Decodable {
    let cast: [CombinedCreditsItemResponse]
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case cast
        case id
    }
}

struct CombinedCreditsItemResponse: Decodable {
    let id: Int
    let mediaType: String
    let originalTitle: String?
    let name: String?
    let posterPath: String?
    let character: String?
    let voteAverage: Double?
    let voteCount: Int?
    let overview: String?
    let releaseDate: String?
    let firstAirDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case originalTitle = "original_title"
        case name
        case posterPath = "poster_path"
        case character
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case overview
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
    }
}
