//
//  GenreSectionViewModel.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol ErrorViewModelProtocol {
    var alertModel: AlertModel? {get}
}

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] {get}
    func fetchGenres() async
}

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorViewModelProtocol {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    @Inject
    private var movieService: MoviesServiceProtocol
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = Environments.name == .tvlist ? try await movieService.fetchTVGenres(req: request) : try await movieService.fetchGenres(req: request)
            
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch {
            DispatchQueue.main.async {
                self.alertModel = self.toAlertModel(error)
            }
        }
    }
    
    private func toAlertModel(_ error: Error) -> AlertModel{
        guard let error = error as? MovieError else {
            return AlertModel(
                title: "unexpected.error.title",
                message: "unexpected.error.message",
                dismissButtonTitle: "button.coles.text"
            )
        }
        
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: "API Error",
                message: message,
                dismissButtonTitle: "button.close.text"
            )
        case .clientError:
            return AlertModel(
                title: "Client error",
                message: error.localizedDescription,
                dismissButtonTitle: "button.close.text"
            )
        default:
            return AlertModel(
                title: "unexpected.error.title",
                message: "unexpected.error.message",
                dismissButtonTitle: "button.close.text"
            )
        }
    }
    
    init() { //reaktiv komponensek
            let request = FetchGenreRequest()
        
//        let subject = PassthroughSubject<[Genre], Error>()
//        subject.send([])
            
            let future = Future<[Genre], Error> { future in
                Task {
                    do {
                        let genres = try await self.movieService.fetchGenres(req: request)
                        future(.success(genres))
                    } catch {
                        future(.failure(error))
                    }
                }
            }
        
        let futureTV = Future<[Genre], Error> { futureTV in
            Task {
                do {
                    let genres = try await self.movieService.fetchTVGenres(req: request)
                    futureTV(.success(genres))
                } catch {
                    futureTV(.failure(error))
                }
            }
        }
        
        //Publishers.CombineLatest(future, futureTV)
        future
            .print("<<<<future")
            .flatMap({genres in
                futureTV
                    .print("<<<<futureTV")
                    .map {genresTV -> ([Genre], [Genre]) in
                    (genres, genresTV)
                }
                    .eraseToAnyPublisher()
            })
            .print("<<<<(genres, genresTV)") //egyik tuple filmek, másik tvhez tartozo műfajok
                .receive(on: RunLoop.main) //ha változik a published értéke, akkor azt a main threaden hajtsa végre
                .sink { completion in
                    switch completion{
                    case .failure(let error):
                        self.alertModel = self.toAlertModel(error)
                    case .finished:
                        break
                    }
//                    if case let .failure(error) = completion {
//                        self.alertModel = self.toAlertModel(error)
//                    }
                } receiveValue: { [weak self] genres, genresTV in
                    self?.genres = genres + genresTV
                }
                .store(in: &cancellables)
        }
    
//    init() { //ugyanaz csak itt PassthroughSubject el van megoldva
//            let request = FetchGenreRequest()
//            
//            let publisher = PassthroughSubject<[Genre], Error>()
//
//            Task {
//                do {
//                    let genres = try await self.movieService.fetchTVGenres(req: request)
//                    publisher.send(genres)
//                    publisher.send(completion: .finished) // FONTOS: befejezés
//                } catch {
//                    publisher.send(completion: .failure(error)) // Hiba küldése
//                }
//            }
//            
//            publisher
//                .receive(on: RunLoop.main)
//                .sink { completion in
//                    switch completion{
//                    case .failure(let error):
//                        self.alertModel = self.toAlertModel(error)
//                    case .finished:
//                        break
//                    }
//                } receiveValue: { genres in
//                    self.genres = genres
//                }
//                .store(in: &cancellables)
//        }
}
