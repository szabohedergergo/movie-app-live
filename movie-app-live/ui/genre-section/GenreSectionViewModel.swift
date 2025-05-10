//
//  GenreSectionViewModel.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 28..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] {get}
}

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorPresentable {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
            let request = FetchGenreRequest()
            
        let genres = Environments.name == .tvlist ? self.service.fetchTVGenres(req: request) :
                                                    self.service.fetchGenres(req: request)
            
        //Publishers.CombineLatest(genresFuture, genresTVFuture)
        genres
            .handleEvents(receiveOutput: { genres in
                print("Custom action before receive: genres count = \(genres.count)")
            })
            .print("<<<debug")
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { genres  in
                self.genres = genres
            }
            .store(in: &cancellables)
        }
    
//    init() { //reaktiv komponensek
//            let request = FetchGenreRequest()
//        
////        let subject = PassthroughSubject<[Genre], Error>()
////        subject.send([])
//        
//        let genresFutures = self.reactiveMoviesService.fetchGenres(req: request)
//        
//        let genresTVFuture = self.reactiveMoviesService.fetchTVGenres(req: request)
//            
//            let future = Future<[Genre], Error> { future in
//                Task {
//                    do {
//                        let genres = try await self.movieService.fetchGenres(req: request)
//                        future(.success(genres))
//                    } catch {
//                        future(.failure(error))
//                    }
//                }
//            }
//        
//        let futureTV = Future<[Genre], Error> { futureTV in
//            Task {
//                do {
//                    let genres = try await self.movieService.fetchTVGenres(req: request)
//                    futureTV(.success(genres))
//                } catch {
//                    futureTV(.failure(error))
//                }
//            }
//        }
//        
//        //Publishers.CombineLatest(future, futureTV)
//        future
//            .print("<<<<future")
//            .flatMap({genres in
//                futureTV
//                    .print("<<<<futureTV")
//                    .map {genresTV -> ([Genre], [Genre]) in
//                    (genres, genresTV)
//                }
//                    .eraseToAnyPublisher()
//            })
//            .print("<<<<(genres, genresTV)") //egyik tuple filmek, másik tvhez tartozo műfajok
//                .receive(on: RunLoop.main) //ha változik a published értéke, akkor azt a main threaden hajtsa végre
//                .sink { completion in
//                    switch completion{
//                    case .failure(let error):
//                        self.alertModel = self.toAlertModel(error)
//                    case .finished:
//                        break
//                    }
////                    if case let .failure(error) = completion {
////                        self.alertModel = self.toAlertModel(error)
////                    }
//                } receiveValue: { [weak self] genres, genresTV in
//                    self?.genres = genres + genresTV
//                }
//                .store(in: &cancellables)
//        }
//        
//        //Publishers.CombineLatest(future, futureTV)
//        future
//            .print("<<<<future")
//            .flatMap({genres in
//                futureTV
//                    .print("<<<<futureTV")
//                    .map {genresTV -> ([Genre], [Genre]) in
//                    (genres, genresTV)
//                }
//                    .eraseToAnyPublisher()
//            })
//            .print("<<<<(genres, genresTV)") //egyik tuple filmek, másik tvhez tartozo műfajok
//                .receive(on: RunLoop.main) //ha változik a published értéke, akkor azt a main threaden hajtsa végre
//                .sink { completion in
//                    switch completion{
//                    case .failure(let error):
//                        self.alertModel = self.toAlertModel(error)
//                    case .finished:
//                        break
//                    }
////                    if case let .failure(error) = completion {
////                        self.alertModel = self.toAlertModel(error)
////                    }
//                } receiveValue: { [weak self] genres, genresTV in
//                    self?.genres = genres + genresTV
//                }
//                .store(in: &cancellables)
//        }
    
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
