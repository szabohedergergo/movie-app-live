//
//  CastMemberCreditsViewModelProtocol.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 06. 28..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol CastMemberCreditsViewModelProtocol: ObservableObject {
    var combinedCredits: [MediaItem] { get }
    var isLoading: Bool { get }
    var alertModel: AlertModel? { get }
    func fetchCredits(forPersonId personId: Int)
}

class CastMemberCreditsViewModel: CastMemberCreditsViewModelProtocol, ErrorPresentable {
    @Published var combinedCredits: [MediaItem] = []
    @Published var isLoading: Bool = false
    @Published var alertModel: AlertModel? = nil
    
    @Inject
    private var repository: MovieRepository // Előzőleg 'service' volt, most 'repository'
    
    private var cancellables = Set<AnyCancellable>()
    
    // A CombineLatest3-as megoldás miatt a DetailViewModel-ben nem a service volt, hanem repository.
    // Érdemes egységesíteni a nevet a MovieRepository-ra a projektedben!
    // @Inject
    // private var service: MovieRepository
    
    func fetchCredits(forPersonId personId: Int) {
        isLoading = true
        let request = FetchCombinedCreditsRequest(personId: personId)
        
        repository.fetchCombinedCredits(req: request)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false // Betöltés befejezése hiba vagy siker esetén
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { [weak self] mediaItems in
                guard let self = self else { return }
                self.combinedCredits = mediaItems // A repository már rendezetten adja vissza
            }
            .store(in: &cancellables)
    }
}
