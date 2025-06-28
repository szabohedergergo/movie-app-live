//
//  MappingError.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 04..
//
import Foundation

enum MappingError: Error, LocalizedError {
    case missingField(String)
    case invalidValue(String)
    
    var errorDescription: String? {
        switch self{
        case .missingField(let field):
            return "Missing required field \(field)"
        case .invalidValue(let field):
            return "Invalid value for field: \(field)"
        }
    }
    
    
}


extension Genre {
    init(validating dto: GenreResponse) throws {
        guard !dto.name.isEmpty else {
            throw MappingError.invalidValue("name")
        }
        
        self.init(id: dto.id, name: dto.name)
    }
}

extension MediaItem {
    init(validating dto: MovieResponse) throws {
        guard !dto.title.isEmpty else {
            throw MappingError.missingField("title")
        }
        
        guard let releaseDate = dto.releaseDate else {
            throw MappingError.missingField("releaseDate")
        }
        
        let year = String(releaseDate.prefix(4))
        guard !year.isEmpty, year != "-" else {
            throw MappingError.invalidValue("releaseDate")
        }
        
        let duration = "1h 25min"
        
        let imageUrl = dto.posterPath.flatMap {
            URL(string: "https://image.tmdb.org/t/p/w500\($0)")
        }
        
        self.init (
            id: dto.id,
            title: dto.title,
            year: year,
            duration: duration,
            imageUrl: imageUrl,
            rating: dto.voteAverage ?? 0.0,
            voteCount: dto.voteCount ?? 0,
            character: dto.character ?? ""
        )
    }
}
