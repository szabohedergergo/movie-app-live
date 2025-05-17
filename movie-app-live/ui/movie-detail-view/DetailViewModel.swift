//
//  DetailViewModel.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 10..
//

import Foundation
import InjectPropertyWrapper
import Combine
//
//protocol DetailViewModelProtocol: ObservableObject {}
//
//class DetailViewModel: DetailViewModelProtocol, ErrorPresentable {
//    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
//    @Published var castMembers: [CastMemberCredit] = []
//    @Published var alertModel: AlertModel? = nil
//    
//    let mediaItemSubject = PassthroughSubject<Int, Never>()
//    
//    @Inject
//    private var service: ReactiveMoviesServiceProtocol
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        // 1. Fetch detail
//        let details = mediaItemSubject
//            .flatMap { [weak self] mediaItemId -> AnyPublisher<MediaItemDetail, MovieError> in
//                guard let self = self else {
//                    return Fail(error: .unexpectedError).eraseToAnyPublisher()
//                }
//                let request = FetchDetailRequest(mediaId: mediaItemId)
//                return self.service.fetchMovieDetail(req: request)
//            }
//        
//        details
//            .receive(on: RunLoop.main)
//            .sink { [weak self] completion in
//                if case let .failure(error) = completion {
//                    self?.alertModel = self?.toAlertModel(error)
//                }
//            } receiveValue: { [weak self] detail in
//                self?.mediaItemDetail = detail
//            }
//            .store(in: &cancellables)
//        
//        // 2. Fetch cast
//        let cast = mediaItemSubject
//            .flatMap { [weak self] mediaItemId -> AnyPublisher<[CastMemberCredit], MovieError> in
//                guard let self = self else {
//                    return Fail(error: .unexpectedError).eraseToAnyPublisher()
//                }
//                let request = FetchMovieCreditsRequest(mediaId: mediaItemId)
//                return self.service.fetchMovieCredits(req: request)
//            }
//        
//        cast
//            .receive(on: RunLoop.main)
//            .sink { [weak self] completion in
//                if case let .failure(error) = completion {
//                    self?.alertModel = self?.toAlertModel(error)
//                }
//            } receiveValue: { [weak self] castList in
//                self?.castMembers = castList
//            }
//            .store(in: &cancellables)
//    }
//}


protocol DetailViewModelProtocol: ObservableObject {
    
}

class DetailViewModel: DetailViewModelProtocol, ErrorPresentable {
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var alertModel: AlertModel? = nil
    @Published var cast: [CastMember] = []
    
    
    let mediaItemSubject = PassthroughSubject<Int, Never>()
    
    //onappear{ viewModel.mediaItemIdSubject.send(mediaItem.id) }
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        let mediaIdSharedPublisher = mediaItemSubject.share()
        
        let details = mediaItemSubject //syncimage
            .flatMap{ [weak self] mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
                return self.service.fetchMovieDetail(req: request)
            }
        
        let creditsPublisher = mediaIdSharedPublisher
                   .flatMap { [weak self] mediaItemId in
                       guard let self = self else {
                           preconditionFailure("There is no self in creditsPublisher")
                       }
                       let request = FetchMovieCreditsRequest(mediaId: mediaItemId)
                       return self.service.fetchMovieCredits(req: request)
                   }
                   .receive(on: RunLoop.main)

        Publishers.CombineLatest(details, creditsPublisher)
                    .receive(on: RunLoop.main)
                    .sink{ [weak self] completion in
                        if case let .failure(error) = completion {
                            self?.alertModel = self?.toAlertModel(error)
                        }
                    } receiveValue: { [weak self] details, creditsPublisher in
                        self?.mediaItemDetail = details
                        self?.cast = creditsPublisher
                    }.store(in: &cancellables)
    }
}
