////
////  ParticipantDetailType.swift
////  movie-app-live
////
////  Created by Gergo Szabo on 2025. 06. 14..
////
//
//import Foundation
//import InjectPropertyWrapper
//import Combine
//
//enum ParticipantDetailType {
//    case person(PersonDetailResponse)
//    case company(CompanyDetailResponse)
//}
//
//protocol ParticipantDetailViewModelProtocol: ObservableObject {
//    var participantDetail: ParticipantDetailType? { get }
//    var alertModel: AlertModel? { get }
//    func fetchParticipantDetail(id: Int, type: ParticipantType)
//}
//
//enum ParticipantType {
//    case person
//    case company
//}
//
//class ParticipantDetailViewModel: ParticipantDetailViewModelProtocol, ErrorPresentable {
//    @Published var participantDetail: ParticipantDetailType? = nil
//    @Published var alertModel: AlertModel? = nil
//    
//    @Inject
//    private var service: MovieRepository
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    func fetchParticipantDetail(id: Int, type: ParticipantType) {
//        switch type {
//        case .person:
//            let request = FetchCastMemberDetailRequest(castMemberId: id)
//            service.fetchCastMemberDetail(req: request)
//                .receive(on: RunLoop.main)
//                .sink { [weak self] completion in
//                    if case let .failure(error) = completion {
//                        self?.alertModel = self?.toAlertModel(error)
//                    }
//                } receiveValue: { [weak self] personDetail in
//                    self?.participantDetail = .person(personDetail)
//                }
//                .store(in: &cancellables)
//        case .company:
//            let request = FetchCompanyDetailRequest(companyId: id)
//            service.fetchCompanyDetail(req: request)
//                .receive(on: RunLoop.main)
//                .sink { [weak self] completion in
//                    if case let .failure(error) = completion {
//                        self?.alertModel = self?.toAlertModel(error)
//                    }
//                } receiveValue: { [weak self] companyDetail in
//                    self?.participantDetail = .company(companyDetail)
//                }
//                .store(in: &cancellables)
//        }
//    }
//}
