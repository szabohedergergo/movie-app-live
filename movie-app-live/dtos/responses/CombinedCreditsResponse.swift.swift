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
    let mediaType: String // "movie" or "tv"
    let originalTitle: String? // Filmekhez
    let name: String? // TV sorozatokhoz (original_name)
    let posterPath: String?
    let character: String? // A karakter neve, amit játszott
    let voteAverage: Double?
    let voteCount: Int?
    let overview: String?
    let releaseDate: String? // Filmekhez
    let firstAirDate: String? // TV sorozatokhoz

    // További mezők, amelyek szerepelnek a response-ban, de nem feltétlenül kellenek a megjelenítéshez
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let originalLanguage: String?
    let popularity: Double?
    let title: String? // A TMDb API 'title'-t ad filmekhez és 'name'-et TV-hez.
    let video: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case originalTitle = "original_title"
        case name // A TV sorozatok 'name' mezője
        case posterPath = "poster_path"
        case character
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case overview
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        
        // Hozzáadott extra mezők
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case popularity
        case title
        case video
    }
}
