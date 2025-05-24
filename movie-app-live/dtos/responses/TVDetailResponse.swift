////
////  TVResponse.swift
////  movie-app-live
////
////  Created by Gergo Szabo on 2025. 05. 06..
////
//
//struct TVPageResponse: Decodable {
//    let page: Int
//    let results: [TVResponse]
//    let totalPages: Int
//    let totalResults: Int
//
//    enum CodingKeys: String, CodingKey {
//        case page
//        case results
//        case totalPages = "total_pages"
//        case totalResults = "total_results"
//    }
//}
//
//struct TVResponse: Decodable {
//    let id: Int
//    let name: String
//    let firstAirDate: String?
//    let posterPath: String?
//    let voteAverage: Double?
//    let voteCount: Int?
//    let overview: String?
//    let popularity: Double?
//    let genres: [GenreResponse]
//    let spokenLanguages: [Language]
//    let homepage: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case firstAirDate = "first_air_date"
//        case posterPath = "poster_path"
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//        case overview
//        case popularity
//        case genres
//        case spokenLanguages = "spoken_languages"
//        case homepage
//    }
//}
