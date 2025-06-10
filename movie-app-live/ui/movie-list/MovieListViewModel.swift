//
//  MovieListViewModel.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol MovieListViewModelProtocol: ObservableObject {
    var movies: [MediaItem] { get }
}

class MovieListViewModel: MovieListViewModelProtocol, ErrorPresentable {
    @Published var movies: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    @Published var isLoading: Bool = false
    @Published var showPaginationLoading: Bool = false
    
    let genreIdSubject = PassthroughSubject<Int, Never>()
    let reachedBottomSubject = CurrentValueSubject<Void, Never>(())
    let refreshSubject = CurrentValueSubject<Void, Never>(())
    
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage: Int = 1
    private var totalPages: Int = Int.max
    
    @Inject
    private var repository: MovieRepository
    
    init() {
        refreshSubject
            .handleEvents(receiveOutput: { [weak self]_ in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                print("HANDLE EVENTS REFRESH SUBJECT")
                self.isLoading = true
                self.movies = []
                refreshMovies(genreId: 0)
            })
        
        Publishers.CombineLatest(reachedBottomSubject, genreIdSubject)
            .filter { [weak self]_ in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                print("check: currentPage=\(self.currentPage), totalPages=\(self.totalPages), shouldFetch=\(self.currentPage < self.totalPages)")
                return self.currentPage < self.totalPages && !self.isLoading
            }
            .handleEvents(receiveOutput: { [weak self]_ in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                print("HANDLE EVENTS: fetching page \(self.currentPage)")
                self.isLoading = true
                
                if self.movies.isEmpty || self.movies.allSatisfy({$0.id < 0}) {
                    self.movies = Array(repeating: MediaItem.placeholder, count: 3)
                }
            })
            //.delay(for: .seconds(3), scheduler: RunLoop.main)
            .flatMap { [weak self] _, genreId -> AnyPublisher<MediaItemPage, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                print("Flatmap for genreid=\(genreId), page=\(self.currentPage), ")
                let request = FetchMediaListRequest(genreId: genreId, includeAdult: true, page: self.currentPage)
                return Environments.name == .tvlist ?
                        self.repository.fetchTV(req: request) :
                        self.repository.fetchMovies(req: request)
                
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                    self?.isLoading = false
                    if self?.movies.allSatisfy({$0.id < 0}) ?? false {
                        self?.movies = []
                    }
                }
            } receiveValue: { [weak self] page in
                guard let self else { return }
                
                print("receive: Fetched page \(page.page) for total \(page.totalPages)")
                
                if self.currentPage == 1 || self.movies.allSatisfy({$0.id < 0}) {
                    print("FIRSTPAGE")
                    self.movies = page.mediaItems
                }
                else{
                    self.movies.append(contentsOf: page.mediaItems)
                }
                
                self.currentPage += 1
                self.totalPages = page.totalPages
                self.isLoading = false
                self.showPaginationLoading = false
            }
            .store(in: &cancellables)
    }
}

extension MovieListViewModel {
    func refreshMovies(genreId: Int) {
        self.currentPage = 1
        self.totalPages = Int.max
        self.movies = []
        
        print("send35325235")
        self.genreIdSubject.send(0)
        self.reachedBottomSubject.send(())
    }
}
