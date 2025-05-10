//
//  SearchViewModel.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import Foundation
import Combine
import InjectPropertyWrapper

protocol SearchViewModelProtocol: ObservableObject {
    var movies: [MediaItem] {get}
    var searchText: String {get set}
    //func searchMovies() async
}

class SearchViewModel: SearchViewModelProtocol, ErrorPresentable {
    @Published var movies: [MediaItem] = []
    @Published var searchText: String = ""
    @Published var alertModel: AlertModel? = nil
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    let startSearch = PassthroughSubject<Void, Never>()
    
    init(){
        startSearch
            .print("<<<<< Start search")
            .debounce(for: .seconds(2.5), scheduler: RunLoop.main)
            .flatMap { [weak self]_ -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = SearchMovieRequest(query: self.searchText)
                return self.service.searchMovies(req: request)
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            }
            receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
    
//    init() {
//        $searchText
//            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
//            .removeDuplicates()
//            .sink { [weak self] text in
//                Task {
//                    await self?.searchMovies()
//                }
//            }
//            .store(in: &cancellables)
//    }
    
//    func searchMovies() async {
//        print("Keresés indult a következő szövegre: \(searchText)")
//        guard !searchText.isEmpty else {
//            DispatchQueue.main.async {
//                self.movies = []
//            }
//            return
//        }
//        
//        do {
//            let request = SearchMovieRequest(query: searchText)
//            let movies = try await service.searchMovies(req: request)
//            
//            DispatchQueue.main.async {
//                self.movies = movies
//            }
//        } catch {
//            print("Error searching movies: \(error)")
//        }
//    }
}
