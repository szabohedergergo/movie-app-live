//
//  AddReviewViewModel.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 24..
//


import Foundation
import InjectPropertyWrapper
import Combine

class AddReviewViewModel: ObservableObject, ErrorPresentable {
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var selectedRating: Int = -1
    
    let mediaDetailSubject = PassthroughSubject<MediaItemDetail, Never>()
    let ratingBtnSubject = PassthroughSubject<Void, Never>()
    
    @Inject
    private var service: MovieRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        mediaDetailSubject
            .sink { [weak self]detail in
                self?.mediaItemDetail = detail
            }
            .store(in: &cancellables)
        
        ratingBtnSubject
            .flatMap { [weak self] _ ->
                AnyPublisher<ModifyMediaResult, MovieError> in
                
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                
                let rating: Double = Double(self.selectedRating)
                let request = AddReviewRequest(mediaId: mediaItemDetail.id, rating: rating)
                
                return self.service.addReview(req: request)
            }
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { result in
                
            })
            .store(in: &cancellables)
    }
}
