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
    var movies: [Movie] {get}
    var searchText: String {get set}
    func searchMovies() async
}

class SearchViewModel: SearchViewModelProtocol {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    
    @Inject
    private var service: MoviesServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                Task {
                    await self?.searchMovies()
                }
            }
            .store(in: &cancellables)
    }
    
    func searchMovies() async {
        print("Keresés indult a következő szövegre: \(searchText)")
        guard !searchText.isEmpty else {
            DispatchQueue.main.async {
                self.movies = []
            }
            return
        }
        
        do {
            let request = SearchMovieRequest(query: searchText)
            let movies = try await service.searchMovies(req: request)
            
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error searching movies: \(error)")
        }
    }
}
