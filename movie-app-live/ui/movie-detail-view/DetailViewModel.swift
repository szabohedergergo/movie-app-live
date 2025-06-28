// DetailViewModel.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 10..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol DetailViewModelProtocol: ObservableObject {
}

class DetailViewModel: DetailViewModelProtocol, ErrorPresentable {
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var credits: [CastMember] = [] // Ezek már CastMember típusúak
    @Published var isFavorite: Bool = false
    @Published var alertModel: AlertModel? = nil
    @Published var similarMovies: [MediaItem] = []
    @Published var isLoadingSimilarMovies: Bool = false
    @Published var reviews: [MovieReview] = []
    
    let mediaItemSubject = PassthroughSubject<MediaItem, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    let fetchMoreSimilarMovies = PassthroughSubject<Void, Never>()
    
    @Inject
    private var repository: MovieRepository
    
    @Inject
    private var mediaItemStore: MediaItemStoreProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    
    init() {
        
        let mediaItemSubject = mediaItemSubject.share()
        
        let details = mediaItemSubject
            .flatMap { [weak self]mediaItem in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItem.id)
                return self.repository.fetchMovieDetail(req: request)
            }
        
        details
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { mediaItemDetail in
                self.currentPage = 1
                self.similarMovies = []
                self.fetchSimilarMovies(mediaId: mediaItemDetail.id)
            }
            .store(in: &cancellables)
        
        
        let credits = mediaItemSubject
            .flatMap { [weak self]mediaItem in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMovieCreditsRequest(mediaId: mediaItem.id)
                return self.repository.fetchMovieCredits(req: request)
            }
        
        let reviews = mediaItemSubject
            .flatMap { [weak self]mediaItem in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMovieReviewsRequest(mediaId: mediaItem.id)
                return self.repository.fetchMovieReviews(req: request)
            }
        
        Publishers.CombineLatest3(details, credits, reviews)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] details, credits, reviews in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.mediaItemDetail = details
                self.credits = credits
                self.reviews = reviews.prefix(4).map { $0 }
                self.isFavorite = self.mediaItemStore.isMediaItemStored(withId: details.id)
            }
            .store(in: &cancellables)
        
        favoriteButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<(EditFavoriteResult, Bool), MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let isFavorite = !self.isFavorite
                let request = EditFavoriteRequest(movieId: self.mediaItemDetail.id, isFavorite: isFavorite)
                return repository.editFavoriteMovie(req: request)
                    .map { result in
                    (result, isFavorite)
                }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] result, isFavorite in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                if result.success {
                    self.isFavorite = isFavorite
                    if isFavorite {
                        self.mediaItemStore.saveMediaItems([MediaItem(detail: self.mediaItemDetail)])
                    } else {
                        self.mediaItemStore.deleteMediaItem(withId: self.mediaItemDetail.id)
                    }
                }
            }
            .store(in: &cancellables)
        
        fetchMoreSimilarMovies
            .filter{ [weak self] _ in
                guard let self = self else { return false }
                return self.currentPage < self.totalPages && !self.isLoadingSimilarMovies
            }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.currentPage += 1
                self.fetchSimilarMovies(mediaId: self.mediaItemDetail.id, page: self.currentPage)
            }
            .store(in: &cancellables)
    }
    
    private func fetchSimilarMovies(mediaId: Int, page: Int = 1){
        isLoadingSimilarMovies = true
        let request = FetchSimilarMoviesRequest(mediaId: mediaId, page: page)
        repository.fetchSimilarMovies(req: request)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoadingSimilarMovies = false
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            }
            receiveValue: { [weak self] mediaItemPage in
                guard let self = self else { return }
                self.similarMovies.append(contentsOf: mediaItemPage.mediaItems)
                self.totalPages = mediaItemPage.totalPages
            }
            .store(in: &cancellables)
    }
    
}
