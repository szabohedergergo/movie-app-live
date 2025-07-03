////
////  FavoritesViewModel.swift
////  movie-app-live
////
////  Created by Gergo Szabo on 2025. 04. 28..
////
//
import Foundation
import Combine
import InjectPropertyWrapper

protocol FavoritesViewModelProtocol: ObservableObject {
    var mediaItems: [MediaItem] { get }
}

class FavoritesViewModel: FavoritesViewModelProtocol, ErrorPresentable {
    @Published var mediaItems: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    let viewLoaded = PassthroughSubject<Void, Never>()
    
    @Inject
    private var service: MovieRepository
    
    @Inject
    private var favoriteMediaStore: FavoriteMediaStoreProtocol
    
    init() {
        
        viewLoaded
                    .flatMap { [weak self]_ -> AnyPublisher<[MediaItem], MovieError> in
                        guard let self = self else {
                            preconditionFailure("There is no self")
                        }
                        return self.service.fetchFavoriteMovies(req: FetchFavoriteMediaRequest(), fromLocal: false)
                    }
                    .receive(on: RunLoop.main)
                    .sink { completion in
                        switch completion {
                        case .failure(let error):
                            self.alertModel = self.toAlertModel(error)
                        case .finished:
                            break
                        }
                    } receiveValue: { [weak self]mediaItems in
                        self?.mediaItems = mediaItems
                    }
                    .store(in: &cancellables)
    }
}

//        let future = Future<[Movie], Error> { future in
//            Task {
//                do {
//                    let genres = try await self.service.fetchFavoriteMovies(req: request)
//                    future(.success(genres))
//                } catch {
//                    future(.failure(error))
//                }
//            }
//        }
//        
//        future
//            .receive(on: RunLoop.main)
//            .sink{ completion in
//                switch completion {
//                case .failure(let error):
//                    self.alertModel = self.toAlertModel(error)
//                case .finished:
//                    break
//                }
//            }receiveValue: { [weak self] movies in
//                self?.movies = movies
//            }
//            .store(in: &cancellable)
//    }


//
//protocol FavoritesViewModelProtocol: ObservableObject {
//    var filteredMovies: [Movie] { get }
//    func loadFavorites() async
//}
//
//class FavoritesViewModel: FavoritesViewModelProtocol {
//    @Published var filteredMovies: [Movie] = []
//
//    private var allMovies: [Movie] = []
//    private var cancellables = Set<AnyCancellable>()
//
//    @Inject
//    private var service: MoviesServiceProtocol
//
//    init() {
//        // reaktív újratöltés
//        FavoritesManager.manager.$favoriteMovieIDs
//            .sink { [weak self] _ in
//                Task {
//                    await self?.loadFavorites()
//                }
//            }
//            .store(in: &cancellables)
//
//        Task {
//            await loadFavorites()
//        }
//    }
//
//    func loadFavorites() async {
//        do {
//            let genreIDs = Array(SelectedGenresManager.selectedGenres.selectedGenreIDs)
//
//            var filteredMovies: [Movie] = []
//
//            // Minden kiválasztott műfajhoz lekérjük a filmeket
//            for genreId in genreIDs {
//                let req = FetchMoviesRequest(genreId: genreId)
//                let movies = try await service.fetchMovies(req: req)
//                filteredMovies.append(contentsOf: movies)
//            }
//
//            let favoriteMovieIDs = FavoritesManager.manager.favoriteMovieIDs
//            let favoriteMovies = filteredMovies.filter { favoriteMovieIDs.contains($0.id) }
//
//            print("items:")
//            print(favoriteMovieIDs)
//
//            DispatchQueue.main.async {
//                self.filteredMovies = favoriteMovies.removingDuplicates(by: \.id)
//
//            print("Done")
//            }
//        } catch {
//            print("Hiba történt a kedvencek betöltésekor: \(error)")
//        }
//    }
//}
