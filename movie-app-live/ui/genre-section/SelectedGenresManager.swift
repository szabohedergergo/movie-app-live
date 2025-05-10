//
//  SelectedGenresManager.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 06..
//

import Foundation
import Combine

class SelectedGenresManager: ObservableObject {
    static let selectedGenres = SelectedGenresManager()

    @Published var selectedGenreIDs: Set<Int> = []

    private init() {}

    func toggleGenre(id: Int) {
        if selectedGenreIDs.contains(id) {
            selectedGenreIDs.remove(id)
        } else {
            selectedGenreIDs.insert(id)
        }
    }

    func resetGenres() {
        selectedGenreIDs.removeAll()
    }
}
