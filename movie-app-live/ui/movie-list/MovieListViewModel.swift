//
//  MovieListViewModel.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol MovieListViewModelProtocol: ObservableObject, ErrorPresentable {
    var movies: [MediaItem] {get}
    func loadMovies(by genreId: Int) async
}

class MovieListViewModel: MovieListViewModelProtocol {
    @Published var movies: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    let genreIdSubject = PassthroughSubject<Int, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init(){
        
        
        genreIdSubject
            .flatMap { [weak self] genreId -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMediaListRequest(genreId: genreId, includeAdult: true)
                return Environments.name == .tvlist ? self.service.fetchTV(req: request) :
                self.service.fetchMovies(req: request)
            }
            .sink{ completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in:  &cancellables)
    }
    
    func loadMovies(by genreId: Int){
        
    }
        
//        do {
//            let request = FetchMoviesRequest(genreId: genreId)
//            let movies = try await service.fetchMovies(req: request)
//            DispatchQueue.main.async{
//                self.movies = movies
//            }
//        } catch {
//            print("Error fetching movies: \(error)")
//        }
}
