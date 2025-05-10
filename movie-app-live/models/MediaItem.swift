//
//  Movie.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 15..
//

import Foundation

struct MediaItem: Identifiable {
    let id: Int
    let title: String
    let year: String
    let duration: String
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int

    let overview: String?
    let runtime: Int?
    let revenue: Int?
    let genres: [Genre]
    let spokenLanguages: [Language]
    let homepage: String?

    let displayDuration: String
    let displayLanguage: String

    init(
        id: Int,
        title: String,
        year: String,
        duration: String,
        imageUrl: URL?,
        rating: Double,
        voteCount: Int,
        overview: String? = nil,
        runtime: Int? = nil,
        revenue: Int? = nil,
        genres: [Genre] = [],
        spokenLanguages: [Language] = [],
        homepage: String? = nil
    ) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
        self.overview = overview
        self.runtime = runtime
        self.revenue = revenue
        self.genres = genres
        self.spokenLanguages = spokenLanguages
        self.homepage = homepage

        self.displayDuration = {
            if let runtime {
                let h = runtime / 60
                let m = runtime % 60
                return "\(h)h \(m)min"
            }
            return "N/A"
        }()

        self.displayLanguage = {
            spokenLanguages.first?.englishName ?? "N/A"
        }()
    }

    init(dto: MovieResponse) {
        let year = dto.releaseDate.prefix(4).description

        let duration = {
            if let runtime = dto.runtime {
                let h = runtime / 60
                let m = runtime % 60
                return "\(h)h \(m)min"
            }
            return "N/A"
        }()

        let imageUrl: URL? = dto.posterPath.flatMap {
            URL(string: "https://image.tmdb.org/t/p/w500\($0)")
        }

        self.init(
            id: dto.id,
            title: dto.title,
            year: year,
            duration: duration,
            imageUrl: imageUrl,
            rating: dto.voteAverage ?? 0.0,
            voteCount: dto.voteCount ?? 0,
            overview: dto.overview,
            runtime: dto.runtime,
            revenue: dto.revenue,
            genres: dto.genres ?? [],
            spokenLanguages: dto.spokenLanguages ?? [],
            homepage: dto.homepage
        )
    }

    init(dto: TVResponse) {
        let year = dto.firstAirDate?.prefix(4).description ?? "-"

        let duration = {
            if let runtime = dto.runtime {
                let h = runtime / 60
                let m = runtime % 60
                return "\(h)h \(m)min"
            }
            return "N/A"
        }()

        let imageUrl: URL? = dto.posterPath.flatMap {
            URL(string: "https://image.tmdb.org/t/p/w500\($0)")
        }

        self.init(
            id: dto.id,
            title: dto.name,
            year: year,
            duration: duration,
            imageUrl: imageUrl,
            rating: dto.voteAverage ?? 0.0,
            voteCount: dto.voteCount ?? 0,
            overview: dto.overview,
            runtime: dto.runtime,
            revenue: dto.revenue,
            genres: dto.genres,
            spokenLanguages: dto.spokenLanguages,
            homepage: dto.homepage
        )
    }
}
