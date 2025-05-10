//
//  MovieService.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 12..
//
//asnyc: ez a metodus async hivást hajt végre
//ne a main threaden / ui threaden, hanem a háttérben futtassa
//await kulccszóval vezéreljük hogy várja meg a funkció
//throws: implementációban fogunk dobni egy hibát is/

import Foundation
import Moya
import InjectPropertyWrapper

struct MovieAPIErrorResponse: Decodable {
    let statusCode: Int
    let statusMessage: String
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case success = "success"
    }
}

protocol MoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchMovies(req: FetchMediaListRequest) async throws -> [MediaItem]
    func searchMovies(req: SearchMovieRequest) async throws -> [MediaItem]
    func fetchFavoriteMovies(req: FetchFavoriteMoviesRequest) async throws -> [MediaItem]
}

class MoviesService: MoviesServiceProtocol {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            //transform: { $0.genres.map(Genre.init(dto:)) }
            transform: { response in
                try response.genres.map { try Genre(validating: $0)}
            }
        )
    }
    
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVGenres(req: req)),
            decodeTo: GenreListResponse.self,
            //transform: { $0.genres.map(Genre.init(dto:)) }
            transform: { response in
                try response.genres.map { try Genre(validating: $0) }
            }
        )
    }
    
    func fetchMovies(req: FetchMediaListRequest) async throws -> [MediaItem] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            //transform: { $0.results.map(Movie.init(dto:)) }
            transform: { response in
                try response.results.map { try MediaItem(validating: $0) }
            }
        )
    }
    
    func searchMovies(req: SearchMovieRequest) async throws -> [MediaItem] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.searchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
//            transform: { (moviePageResponse: MoviePageResponse) in
//                moviePageResponse.results.map(Movie.init(dto:))
//            }
            transform: {
                response in
                
                try response.results.map { try MediaItem(validating: $0) }
            }
        )
    }
    
    func fetchFavoriteMovies(req: FetchFavoriteMoviesRequest) async throws -> [MediaItem] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            //transform: { $0.results.map(Movie.init(dto:)) }
            transform: { response in
                try response.results.map { try MediaItem(validating: $0) }
            }
        )
    }
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) throws -> Output
    ) async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            moya.request(target) { result in
                switch result {
                case .success(let response):
                    
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = try transform(decoded)
                            continuation.resume(returning: output)
                        } catch {
                            continuation.resume(throwing: MovieError.unexpectedError)
                        }
                    case 400..<500:
                        continuation.resume(throwing: MovieError.clientError)
                    default:
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                continuation.resume(throwing: MovieError.invalidApiKeyError(message: apiError.statusMessage))
                            } else {
                                continuation.resume(throwing: MovieError.unexpectedError)
                            }
                            return
                        }
                    }
                case .failure:
                    continuation.resume(throwing: MovieError.unexpectedError)
                }
            }
        }
    }
}
