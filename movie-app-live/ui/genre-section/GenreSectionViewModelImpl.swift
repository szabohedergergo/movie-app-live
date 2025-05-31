//
//  GenreSectionViewModel.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol GenreSectionViewModel: ObservableObject {
    var genres: [Genre] { get }
    func loadGenres()
    func genresAppeared()
}

class GenreSectionViewModelImpl: GenreSectionViewModel, ErrorPresentable {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    @Published var highlightedMovie: MediaItem? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var useCase: GenreSectionUseCase
    
    @Inject
    private var mediaItemRepository: MediaItemStoreProtocol
    
    @Inject
    private var movieRepository: MovieRepository
    
    init() {
        useCase.showAppearPopup
            .compactMap { showAppearPopup -> AlertModel? in
                if showAppearPopup {
                    return AlertModel(title: "[[Értékeld az appot]]", message: "[[Értékeld az appot]]", dismissButtonTitle: "[[Rendber]]")
                }
                return nil
            }
            .sink { [weak self]alertModel in
                self?.alertModel = alertModel
            }
            .store(in: &cancellables)
    }
    
    func loadGenres() {
        useCase.loadGenres()
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { genres in
                self.genres = genres
            }
            .store(in: &cancellables)
    }
    
    func genresAppeared() {
        useCase.genresAppeared()
    }
    
    func loadHighlightedMovie() {
           let request: FetchMediaListRequest
           if Environments.name == .tvlist {
               request = FetchMediaListRequest(genreId: 10759, includeAdult: false) // TV akció
           } else {
               request = FetchMediaListRequest(genreId: 28, includeAdult: false) // film akció
           }
           
           let publisher = Environments.name == .tvlist ?
               movieRepository.fetchTV(req: request) :
               movieRepository.fetchMovies(req: request)

           publisher
               .map { $0.first } // első film
               .receive(on: DispatchQueue.main)
               .sink { [weak self] completion in
                   if case let .failure(error) = completion {
                       print("Hiba a kiemelt film betöltésekor: \(error)")
                       //alertmodel
                   }
               } receiveValue: { [weak self] movie in
                   self?.highlightedMovie = movie
               }
               .store(in: &cancellables)
           
       }
}
