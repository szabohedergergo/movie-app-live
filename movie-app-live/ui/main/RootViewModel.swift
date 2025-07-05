//
//  RootViewModel.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 17..
//


import Foundation
import InjectPropertyWrapper
import Combine

class RootViewModel: ObservableObject {
    
    @Inject
    private var networkMonitor: NetworkMonitorProtocol
    
    @Published var isBannerAppear: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        networkMonitor.isConnected
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self]isConnected in
                if !isConnected {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        self?.isBannerAppear = false
                    }
                }
            })
            .store(in: &cancellables)

    }
}
