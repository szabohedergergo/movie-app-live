//
//  Movie.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 15..
//

import Foundation

struct MediaItemDetail: Identifiable {
    let id: Int
    let title: String
    let year: String
    let runtime: Int
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int
    let overview: String
    let popularity: Double
    let adult: Bool
    let genres: [String]
    let spokenLanguages: String
    let productionCompany: [ProductionCompany]
    
    init() {
        self.id = 0
        self.title = ""
        self.year = ""
        self.runtime = 0
        self.imageUrl = nil
        self.rating = 0.0
        self.voteCount = 0
        self.overview = ""
        self.popularity = 0.0
        self.adult = false
        self.genres = []
        self.spokenLanguages = ""
        self.productionCompany = []
    }
    
    init(id: Int, title: String,
         year: String,
         runtime: Int,
         imageUrl: URL?,
         rating: Double,
         voteCount: Int,
         overview: String = "",
         popularity: Double = 0,
         adult: Bool = false,
         genres: [String] = [],
         spokenLanguages: String = "",
         productionCompany: [ProductionCompany] = []
    ) {
        self.id = id
        self.title = title
        self.year = year
        self.runtime = runtime
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
        self.overview = overview
        self.popularity = popularity
        self.adult = adult
        self.genres = genres
        self.spokenLanguages = spokenLanguages
        self.productionCompany = productionCompany
    }
    
    init(dto: MovieDetailResponse) {
        let releaseDate: String? = dto.releaseDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.title
        self.year = year
        self.runtime = dto.runtime
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.overview = dto.overview
        self.popularity = dto.popularity
        self.adult = dto.adult
        self.genres = dto.genres.map({ $0.name })
        self.spokenLanguages = dto.spokenLanguages
            .map({ $0.englishName })
            .joined(separator: ", ")
        self.productionCompany = dto.productionCompany.map(ProductionCompany.init(dto:))
    }
    
    var genreList: String {
        genres.joined(separator: ", ")
    }
    
}
