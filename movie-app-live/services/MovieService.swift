//
//  MovieService.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 12..
//
import Moya
import Foundation
import InjectPropertyWrapper

protocol MoviesServiceProtocol{
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie]
}
//asnyc: ez a metodus async hivást hajt végre
//ne a main threaden / ui threaden, hanem a háttérben futtassa
//await kulccszóval vezéreljük hogy várja meg a funkció
//throws: implementációban fogunk dobni egy hibát is/

class MovieService: MoviesServiceProtocol{
//    var moya: MoyaProvider<MultiTarget>!
//    
//    init(){
//        let configuration = URLSessionConfiguration.default
//        configuration.headers = .default
//        
//        self.moya = MoyaProvider<MultiTarget>(
//            session: Session(configuration: configuration, startRequestsImmediately: false),
//            plugins: [
//                NetworkLoggerPlugin()
//            ]
//        )
//    }
    
    @Inject
    var moya: MoyaProvider<MultiTarget>
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]{
        //return []
        return try await withCheckedThrowingContinuation { continuation in
            moya.request(MultiTarget(MoviesApi.fetchGenres(req: req))) { result in
                switch result {
                    //responsa.data: data = byte arrays
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(GenreListResponse.self, from: response.data)
                        
//                        var genres = [Genre]()
//                        for genreResponse in decodedResponse.genres {
//                            genres.append(Genre(dto: genreResponse))
//                        }
                        
                        let genres = decodedResponse.genres.map {genreResponse in
                            Genre(dto: genreResponse)
                        } //funkcionális programozás
                        
                        continuation.resume(returning: genres)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre]{
        //return []
        return try await withCheckedThrowingContinuation { continuation in
            moya.request(MultiTarget(MoviesApi.fetchTVGenres(req: req))) { result in
                switch result {
                    //responsa.data: data = byte arrays
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(GenreListResponse.self, from: response.data)
                        
//                        var genres = [Genre]()
//                        for genreResponse in decodedResponse.genres {
//                            genres.append(Genre(dto: genreResponse))
//                        }
                        
                        let genres = decodedResponse.genres.map {genreResponse in
                            Genre(dto: genreResponse)
                        } //funkcionális programozás
                        
                        continuation.resume(returning: genres)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie] {
            return try await withCheckedThrowingContinuation { continuation in
                moya.request(MultiTarget(MoviesApi.fetchMovies(req: req))) { result in
                    switch result {
                    case .success(let response):
                        do {
                            let decodedResponse = try JSONDecoder().decode(MoviePageResponse.self, from: response.data)
                            let movies = decodedResponse.results.map { Movie(dto: $0) }
                            continuation.resume(returning: movies)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
}
