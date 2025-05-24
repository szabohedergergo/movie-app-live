//
//  CastMembers.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 11..
//

import Foundation


struct CastMemberResponse: Codable, Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
    }
}



//struct CastMemberCredit: Identifiable {
//    let id: Int
//    let name: String
//    let castImageURL: URL?
//    
//    init() {
//        self.id = 0
//        self.name = ""
//        self.castImageURL = nil
//    }
//    
//    init(id: Int,
//         name: String,
//         castImageURL: URL?
//    ) {
//        self.id = id
//        self.name = name
//        self.castImageURL = castImageURL
//    }
//    
//    init(dto: MovieDetailResponse) {
//        var castImageURL: URL? {
//            dto.profilePath.flatMap {
//                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
//            }
//        }
//        
//        self.id = dto.id
//        self.name = dto.title
//        self.castImageURL = castImageURL
//        self.runtime = dto.runtime
//        self.imageUrl = imageUrl
//        self.rating = dto.voteAverage ?? 0.0
//        self.voteCount = dto.voteCount ?? 0
//        self.overview = dto.overview
//        self.popularity = dto.popularity
//        self.adult = dto.adult
//        self.genres = dto.genres.map({ $0.name })
//        self.spokenLanguages = dto.spokenLanguages
//            .map({ $0.englishName })
//            .joined(separator: ", ")
//    }
//    
//    var genreList: String {
//        genres.joined(separator: ", ")
//    }
//    
//}
