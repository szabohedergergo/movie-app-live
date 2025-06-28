//
//  Movie.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 15..
//

import Foundation

struct MediaItemPage {
    let page: Int
    let totalPages: Int
    let mediaItems: [MediaItem]
    
    init(dto: MoviePageResponse) {
        self.page = dto.page
        self.totalPages = dto.totalPages
        self.mediaItems = dto.results.map(MediaItem.init(dto:))
    }
    
    init(dto: TVPageResponse) {
        self.page = dto.page
        self.totalPages = dto.totalPages
        self.mediaItems = dto.results.map(MediaItem.init(dto:))
    }
}

struct MediaItem: Identifiable {
    let id: Int
    let title: String
    let year: String
    let duration: String
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int
    let character: String?
    
    static let placeholder = MediaItem(id: -1, title: "", year: "", duration: "", imageUrl: nil, rating: 0.0, voteCount: 0, character: nil)
    
    init(id: Int) {
        self.id = id
        self.title = "-1"
        self.year = "-1"
        self.duration = "-1"
        self.imageUrl = nil
        self.rating = -1
        self.voteCount = -1
        self.character = nil
    }
    
    init(id: Int, title: String, year: String, duration: String, imageUrl: URL?, rating: Double, voteCount: Int, character: String?) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
        self.character = character
    }
    
    init(dto: MovieResponse) {
        let releaseDate: String? = dto.releaseDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "1h 25min" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.character = nil
    }
    
    init(dto: TVResponse) {
        let releaseDate: String? = dto.firstAirDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "1h 25min" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.name
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.character = nil
    }
    
    init(detail: MediaItemDetail) {
        self.id = detail.id
        self.title = detail.title
        self.year = detail.year
        self.duration = "1h 25min"
        self.imageUrl = detail.imageUrl
        self.rating = detail.rating
        self.voteCount = detail.voteCount
        self.character = nil
    }
    
    init?(combinedCreditDto dto: CombinedCreditsItemResponse) {
        let displayTitle: String
        let year: String
        
        if dto.mediaType == "movie" {
            guard let originalTitle = dto.originalTitle else { return nil }
            displayTitle = originalTitle
            year = String(dto.releaseDate?.prefix(4) ?? "-")
        } else if dto.mediaType == "tv" {
            guard let name = dto.name else { return nil }
            displayTitle = name
            year = String(dto.firstAirDate?.prefix(4) ?? "-")
        } else {
            return nil
        }

        self.id = dto.id
        self.title = displayTitle
        self.year = year
        self.duration = "N/A"
        self.imageUrl = dto.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0)") }
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.character = dto.character
    }
    
}
