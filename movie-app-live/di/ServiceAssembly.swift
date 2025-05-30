//
//  ServiceAssembly.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 15..
//

import Swinject
import Moya
import Foundation

class ServiceAssembly: Assembly {
    //ez adja azokat az objektumokat amiket kérünk tőle
    //assemble(container) metódussal
    //container: beletesszük azokat az elemeket, melyek majd a service assemblyn keresztül kikérünk
    
    func assemble(container: Container){
        container.register(MoyaProvider<MultiTarget>.self){ _ in
            let configuration = URLSessionConfiguration.ephemeral
            configuration.headers = .default
            
            return MoyaProvider<MultiTarget>( //ne a konstruktorban legyen példányositvan a movieservice-ben, hanem di-vel
                session: Session(configuration: configuration,
                                 startRequestsImmediately: false),
                plugins: [
                    NetworkLoggerPlugin(
                        configuration: NetworkLoggerPlugin.Configuration(
                            output: { _, items in
                                items.forEach { item in
                                    print("Response \(item)")
                                }
                            },
                            logOptions: .requestBody))
                ])
        }.inObjectScope(.container)
        
        container.register(MoviesServiceProtocol.self) { _ in //tedd bele a protocolba ha erre hivatkozok a jövőben
            //return MockMoviesService() //MovieService() //mindig ugyanazt adja vissza a singleton miatt
            return MoviesService()
            //ha azt akarjuk h mindig egy uj object jöjjön létre: .inObjectScope(.transient)
        }.inObjectScope(.container) //ha containerrel hivunk le, akkor az egész projekten belül csak 1 lehet
        //singleton: olyan osztály, melyből az egész projekten belül csak 1 lehet
        // nem lehet példányositani
        
        container.register(MovieRepository.self) { _ in
            return MovieRepositoryImpl()
        }.inObjectScope(.container)
        
        container.register(MediaItemStoreProtocol.self) { _ in
            return MediaItemStore()
        }.inObjectScope(.container)
        
        container.register(MediaItemDetailStoreProtocol.self) { _ in
            return MediaItemDetailStore()
        }.inObjectScope(.container)
        
        container.register(CastMemberStoreProtocol.self) { _ in
            return CastMemberStore()
        }.inObjectScope(.container)
        
        container.register(NetworkMonitorProtocol.self) { _ in
            return NetworkMonitor()
        }.inObjectScope(.container)
        
        container.register(FavoriteMediaStoreProtocol.self) { _ in
            return FavoriteMediaStore()
        }.inObjectScope(.container)
        
        container.register(GenreSectionUseCase.self) { _ in
            return GenreSectionUseCaseImpl()
        }.inObjectScope(.container)
    }
}
