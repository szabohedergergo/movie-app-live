//
//  SearchSettingsViewModel.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 04. 29..
//

import Foundation
import Combine

protocol SettingsViewModelProtocol: ObservableObject{
}

class SettingsViewModel: SettingsViewModelProtocol {
    var selectedLanguage = CurrentValueSubject<String, Never>("en")
    var selectedTheme = CurrentValueSubject<String, Never>("system")
    
    var cancellables = Set<AnyCancellable>()

    
    init(){
        selectedLanguage
            .sink { lang in
                print("lang changed to \(lang)")
                
            }
            .store(in: &cancellables)
    }
}
